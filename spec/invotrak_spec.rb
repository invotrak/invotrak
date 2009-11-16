require File.dirname(__FILE__) + '/spec_helper'

describe Invotrak do
  before(:each) do
    @invotrak = Invotrak.new
    @invotrak.establish_connection!('some_key')
  end

  describe "clients" do
    it "should list" do
      clients = @invotrak.clients
      clients.class.should == Array
      
      client = clients.first
      client.class.should == Invotrak::Record
      client.id.should == 1
      client.name.should == "Test Client"
    end
    
    it "should find by ID" do
      client = @invotrak.client('1')
      client.class.should == Invotrak::Record
      client.id.should == 1
      client.name.should == "Test Client"
    end
    
    it "should find by exact name" do
      client = @invotrak.client('Test Client')
      client.class.should == Invotrak::Record
      client.id.should == 1
      client.name.should == "Test Client"
    end
    
    it "should find by partial name" do
      client = @invotrak.client('Test')
      client.class.should == Invotrak::Record
      client.id.should == 1
      client.name.should == "Test Client"
    end
    
    it "should create a new client" do
      r = @invotrak.create_client("Test Client")
      r.class.should == Invotrak::Record
      r.result.should == "success"
    end
  end
  
  describe "projects" do
    it "should list" do
      projects = @invotrak.projects
      projects.class.should == Array
      
      project = projects.first
      project.class.should == Invotrak::Record
      project.id.should == 1
      project.name.should == "Test Project"
    end
  end
  
  describe "invoices" do
    it "should list outstanding" do
      invoices = @invotrak.outstanding_invoices("2009-09-01", "2009-11-01")
      invoices.class.should == Array
      
      invoice = invoices.first
      invoice.class.should == Invotrak::Record
      invoice.id.should == 1
      invoice.invoice_id.should == "001-A"
    end
    
    it "should list paid" do
      invoices = @invotrak.paid_invoices("2009-09-01", "2009-11-01")
      invoices.class.should == Array
      
      invoice = invoices.first
      invoice.class.should == Invotrak::Record
      invoice.id.should == 1
      invoice.invoice_id.should == "001-A"
    end
    
    it "should create a new invoice" do
      r = @invotrak.create_invoice(1, Date.today, "100.00", "123-ABC", "30", "Test")
      r.class.should == Invotrak::Record
      r.result.should == "success"
    end
  end
end