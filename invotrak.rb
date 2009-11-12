require 'net/https'
require 'date'
require 'time'
require 'cgi'

begin
  require 'xmlsimple'
rescue LoadError
  begin
    require 'rubygems'
    require 'xmlsimple'
  rescue LoadError
    abort <<-ERROR
The 'xml-simple' library could not be loaded. If you have RubyGems installed
you can install xml-simple by doing "gem install xml-simple".
ERROR
  end
end

class Invotrak
  attr_reader :user, :password, :api_key

  class Connection #:nodoc:
    def initialize(master)
      @master = master
      @connection = Net::HTTP.new("invotrak.com", 443)
      # @connection = Net::HTTP.new("localhost", 3000)
      # @connection.use_ssl = false
      @connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    def post(path, body, headers = {})
      request = Net::HTTP::Post.new(path, headers.merge('Accept' => 'application/xml'))
      request.basic_auth(@master.user, @master.password) unless @api_key
      @connection.request(request, body)
    end
  end
  
  def establish_connection_basic!(user, password)
    @user = user
    @password = password
    @connection = Connection.new(self)
  end
  
  def establish_connection!(api_key)
    @api_key = api_key
    @connection = Connection.new(self)
  end

  def connection
    @connection || raise('No connection established')
  end
  
  def clients
    records "client", "/clients/list"
  end
  
  def client(find)
    record "/client/#{CGI.escape(find)}"
  end
  
  def projects
    records "project", "/projects/list"
  end
  
  # returns at most 100 unpaid invoices between issued_from and issued_to
  def outstanding_invoices(issued_from, issued_to)
    records "invoice", "/invoices/outstanding/#{issued_from}/#{issued_to}"
  end
  
  # returns at most 100 paid invoices between issued_from and issued_to
  def paid_invoices(issued_from, issued_to)
    records "invoice", "/invoices/paid/#{issued_from}/#{issued_to}"
  end
  
  def create_timesheet(client_id, entry, time_in_minutes, entry_for)
    record "/create/timesheet", :client_id => client_id,
                                :entry => entry,
                                :period => time_in_minutes,
                                :entry_for => entry_for
  end
  
  private
  
  class Record #:nodoc:
    attr_reader :type

    def initialize(type, hash)
      @type, @hash = type, hash
    end

    def [](name)
      name = dashify(name)

      case @hash[name]
      when Hash then 
        @hash[name] = if (@hash[name].keys.length == 1 && @hash[name].values.first.is_a?(Array))
          @hash[name].values.first.map { |v| Record.new(@hash[name].keys.first, v) }
        else
          Record.new(name, @hash[name])
        end
      else
        @hash[name]
      end
    end

    def id
      @hash['id']
    end

    def attributes
      @hash.keys
    end

    def respond_to?(sym)
      super || @hash.has_key?(dashify(sym))
    end

    def method_missing(sym, *args)
      if args.empty? && !block_given? && respond_to?(sym)
        self[sym]
      else
        super
      end
    end

    def to_s
      "\#<Record(#{@type}) #{@hash.inspect[1..-2]}>"
    end

    def inspect
      to_s
    end

    private

      def dashify(name)
        name.to_s.tr("_", "-")
      end
  end
  
  # Note: much of the connection logic/architecture comes from the Basecamp ruby API
  def request(path, parameters = {})
    parameters.merge!(:api_key => @api_key) if @api_key
    response = connection.post("/api/2.0.0#{path}", parameters.to_legacy_xml, "Content-Type" => "application/xml")

    if response.code.to_i / 100 == 2
      result = XmlSimple.xml_in(response.body, 'keeproot' => true, 'contentkey' => '__content__', 'forcecontent' => true)
      typecast_value(result)
    else
      raise "#{response.message} (#{response.code})"
    end
  end
  
  def typecast_value(value)
    case value
    when Hash
      if value.has_key?("__content__")
        content = translate_entities(value["__content__"]).strip
        case value["type"]
        when "integer"  then content.to_i
        when "boolean"  then content == "true"
        when "datetime" then Time.parse(content)
        when "date"     then Date.parse(content)
        else                 content
        end
      # a special case to work-around a bug in XmlSimple. When you have an empty
      # tag that has an attribute, XmlSimple will not add the __content__ key
      # to the returned hash. Thus, we check for the presense of the 'type'
      # attribute to look for empty, typed tags, and simply return nil for
      # their value.
      elsif value.keys == %w(type)
        nil
      elsif value["nil"] == "true"
        nil
      # another special case, introduced by the latest rails, where an array
      # type now exists. This is parsed by XmlSimple as a two-key hash, where
      # one key is 'type' and the other is the actual array value.
      elsif value.keys.length == 2 && value["type"] == "array"
        value.delete("type")
        typecast_value(value)
      else
        value.empty? ? nil : value.inject({}) do |h,(k,v)|
          h[k] = typecast_value(v)
          h
        end
      end
    when Array
      value.map! { |i| typecast_value(i) }
      case value.length
      when 0 then nil
      when 1 then value.first
      else value
      end
    end
  end
  
  def translate_entities(value)
    value.gsub(/&lt;/, "<").
          gsub(/&gt;/, ">").
          gsub(/&quot;/, '"').
          gsub(/&apos;/, "'").
          gsub(/&amp;/, "&")
  end
  
  def record(path, parameters={})
    result = request(path, parameters)
    (result && !result.empty?) ? Record.new(result.keys.first, result.values.first) : nil
  end
  
  def records(node, path, parameters={})
    result = request(path, parameters).values.first or return []
    result = result[node] or return []
    result = [result] unless Array === result
    result.map { |row| Record.new(node, row) }
  end
end

# A minor hack to let Xml-Simple serialize symbolic keys in hashes
class Symbol
  def [](*args)
    to_s[*args]
  end
end

class Hash
  def to_legacy_xml
    XmlSimple.xml_out({:request => self}, 'keeproot' => true, 'noattr' => true)
  end
end
