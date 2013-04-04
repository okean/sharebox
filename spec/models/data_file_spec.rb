require 'spec_helper'

describe DataFile do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    @data_file = @user.data_files.new
  end
  
  it { @data_file.should have_attached_file(:uploaded_file) }
  it { @data_file.should validate_attachment_presence(:uploaded_file) }
  it { @data_file.should validate_attachment_size(:uploaded_file).
                less_than(10.megabytes) }
  
  it "should respond to user attribute" do
    @data_file.should respond_to(:user)
  end
  
  it "should respond to folder attribute" do
    @data_file.should respond_to(:folder)
  end
  
  it "should respond to file_name attribute" do
    @data_file.should respond_to(:file_name)
  end
  
  it "should respond to file_size attribute" do
    @data_file.should respond_to(:file_size)
  end
end