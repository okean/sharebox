require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { name: 'Test User', email: 'test.user@sharebox.com',
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
end
