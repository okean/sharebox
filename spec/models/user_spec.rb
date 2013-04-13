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
  
  it "should have a shared_folders_by_others attribute" do
    @user.should respond_to(:shared_folders_by_others)
  end
  
  it "should have a has_share_access? method" do
    @user.should respond_to(:has_share_access?)
  end
  
  describe "has_share_access?" do
    
    before(:each) do
      @folder = FactoryGirl.create(:folder, user: @user)
    end
    
    it "should return true for a user's folders" do
      @user.has_share_access?(@folder).should be_true
    end

    it "should return true for a user's being shared folders" do
      another_user = FactoryGirl.create(:user, email: "another@sharebox.com")
      being_shared = FactoryGirl.create(:folder, user: another_user)
      shared = FactoryGirl.create(:shared, user: another_user,
                                            folder: being_shared, shared_email: @user.email)
      @user.has_share_access?(being_shared).should be_true
    end
    
    it "should return true for a nested folder in a being shared one" do
      another_user = FactoryGirl.create(:user, email: "another@sharebox.com")
      being_shared = FactoryGirl.create(:folder, user: another_user)
      shared = FactoryGirl.create(:shared, user: another_user,
                                            folder: being_shared, shared_email: @user.email)
      nested = FactoryGirl.create(:folder, user: @user, parent_id: being_shared.id)
      @user.has_share_access?(nested).should be_true
    end
    
    it "should return false for an somebody else's folder" do
      another_user = FactoryGirl.create(:user, email: "another@sharebox.com")
      not_being_shared = FactoryGirl.create(:folder, user: another_user)
      @user.has_share_access?(not_being_shared).should be_false
    end
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
  
  describe "Sync new user with shared folders" do
    
    before(:each) do
      @folder = FactoryGirl.create(:folder, user: @user)
      @shared_folder = FactoryGirl.create(:shared, user: @user,
                                          shared_email: 'being_shared@test.com', folder: @folder)
    end
    
    it "should assign shared folder to newly created user" do
      shared_user = FactoryGirl.create(:user, email: 'being_shared@test.com')
      shared_user.being_shared_folders.should include(@shared_folder)
    end
    
    it "should not assign folder to a not being shared user" do
      shared_user = FactoryGirl.create(:user, email: 'not_being_shared@test.com')
      shared_user.being_shared_folders.should_not include(@shared_folder)
    end
  end
end