require 'spec_helper'

describe Folder do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    @attr = { name: "test_folder" }
  end
  
  it "should create a folder given valid attributes" do
    @user.folders.create!(@attr)
  end
  
  it "should require a valid name" do
    @user.folders.new(@attr.merge(name: "")).should_not be_valid
  end
  
  it "should reject folders with long names" do
    long_name = 'a' * 41
    @user.folders.new(@attr.merge(name: long_name)).should_not be_valid
  end
  
  describe "parent and children associations" do
    
    before(:each) do
      @folder = @user.folders.create!(@attr)
    end
    
    it "should have a children attribute" do
      @folder.should respond_to(:children)
    end
    
    it "should have a parent attrbute" do
      @folder.should respond_to(:parent)
    end
    
    it "should create a children node" do
      @folder.children.new(@attr).should be_valid
    end
    
    it "should return children node" do
      @child_folder = @folder.children.create(@attr)
      @folder.children.first.should == @child_folder
    end
    
    it "should return parent node" do
      @child_folder = @folder.children.create(@attr)
      @child_folder.parent == @folder
    end
  end
end
