require 'spec_helper'

describe SharedFolder do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    @attr = { folder_id: 1, shared_email: "test@sharebox.com", message: "test message"}
  end
  
  it "should create a new instance given a valid attributes" do
    @user.shared_folders.create!(@attr)
  end
  
  it "should accept valid emails addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      @user.shared_folders.new(@attr.merge({ shared_email: address })).should be_valid
    end
  end
  
  it "should reject invalid emails addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      @user.shared_folders.new(@attr.merge({ shared_email: address })).should_not be_valid
    end
  end
  
  it "should require an email address" do
    @user.shared_folders.new(@attr.merge({ shared_email: "" })).should_not be_valid
  end
  
  it "should require a folder id" do
    @user.shared_folders.new(@attr.merge({ folder_id: "" })).should_not be_valid
  end
  
  it "should require a user id" do
    SharedFolder.new(@attr).should_not be_valid
  end
  
  it "should assign a correct user given an existent email" do
    user = FactoryGirl.create(:user, email: "being_shared@sharebox.com")
    shared_folder = @user.shared_folders.create!(@attr.merge({ shared_email: user.email }))
    shared_folder.shared_user_id.should == user.id
  end
  
  it "should have a user attribute" do
    @user.shared_folders.new(@attr).should respond_to(:user)
  end
  
  it "should have a shared_user atribute" do
    @user.shared_folders.new(@attr).should respond_to(:shared_user)
  end
  
  it "should have a folder attribute" do
    @user.shared_folders.new(@attr).should respond_to(:folder)
  end
end
