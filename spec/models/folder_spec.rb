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
  
  it "should have a user atribute" do
    @user.folders.new(@attr).should respond_to(:user)
  end
  
  it "should have a data_files attribute" do
    @user.folders.new(@attr).should respond_to(:data_files)
  end
  
  it "should have shared? method" do
    @user.folders.new(@attr).should respond_to(:shared?)
  end
  
  describe "shared? method" do
    
    before(:each) do
      @folder = FactoryGirl.create(:folder, user: @user)
    end
    
    it "should return false for not shared folders" do
      @folder.shared?.should be_false
    end
    
    it "should return true for shared folders" do
      shared_folder = FactoryGirl.create(:shared, user: @user, folder: @folder)
      @folder.shared?.should be_true
    end
  end
  
  describe "DataFiles associations" do
    
    before(:each) do
      @folder = FactoryGirl.create(:folder, user: @user)
      @file = FactoryGirl.create(:data_file, user: @user, folder_id: @folder.id)
    end
    
    it "should destroy related files" do
      @folder.destroy
      DataFile.find_by_id(@file).should be_nil
    end
  end
  
  describe "Shared folders associations" do
    
    before(:each) do
      @folder = FactoryGirl.create(:folder, user: @user)
      @shared_folder = FactoryGirl.create(:shared, user: @user, folder: @folder)
    end
    
    it "should destroy related files" do
      @folder.destroy
      SharedFolder.find_by_id(@shared_folder).should be_nil
    end
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
