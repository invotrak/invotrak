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
end