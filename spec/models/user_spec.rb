require 'spec_helper'

describe User do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    @attr = { name: 'Test User', email: 'test1.user@sharebox.com',
              password: 'foobar', password_confirmation: 'foobar' }
  end
  
  it "should create a new instance given a valid attributes" do
    User.create!(@attr)
  end
  
  it "should require an email" do
    User.new(@attr.merge(email: '')).should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    User.create!(@attr)
    upcase_email = @attr[:email].upcase
    User.new(@attr.merge(email: upcase_email)).should_not be_valid
  end
  
  it "should have a data_files attribute" do
    @user.should respond_to(:data_files)
  end
  
  it "should have a folders attrbute" do
    @user.should respond_to(:folders)
  end
  
  it "should have a shared_folders attribute" do
    @user.should respond_to(:shared_folders)
  end
  
  it "should have a being_shared_folders attribute" do
    @user.should respond_to(:shared_folders)
  end
  
  describe "DataFiles associations" do
    
    before(:each) do
      @file = FactoryGirl.create(:data_file, user: @user)
    end
    
    it "should destroy related files" do
      @user.destroy
      DataFile.find_by_id(@file).should be_nil
    end
  end
  
  describe "Folders associations" do
    
    before(:each) do
      @folder = FactoryGirl.create(:folder, user: @user)
    end
    
    it "should destroy related files" do
      @user.destroy
      Folder.find_by_id(@folder).should be_nil
    end
  end
  
  describe "Shared folders associations" do
    before(:each) do
      @being_shared = FactoryGirl.create(:user, email: "being_shared@test.com")
      @shared_folder = FactoryGirl.create(:shared, user: @user, shared_email: @being_shared.email)
    end
    
    it "should destroy related shared folders" do
      @user.destroy
      SharedFolder.find_by_id(@shared_folder).should be_nil
    end
    
    it "should destroy related shared folders if shared user destroyed" do
      @being_shared.destroy
      SharedFolder.find_by_id(@shared_folder).should be_nil
    end
  end
end
