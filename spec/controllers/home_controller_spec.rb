require 'spec_helper'

describe HomeController do
  render_views

  describe "GET 'index'" do
    
    it "should be successfull" do
      get :index
      response.should be_success
    end
    
    it "should have the right title" do
      get :index
      response.should have_selector('title', content: 'Sharebox | File-sharing web app')
    end
    
    it "should show a welcome message" do
      get :index
      response.should have_selector('h1', content: 'Welcome to ShareBox')
    end
    
    context "when signed in" do
      
      before(:each) do
        user = FactoryGirl.create(:user)
        sign_in user
        
        file2 = FactoryGirl.create(:data_file, user: user,
                            uploaded_file: FactoryGirl.generate(:file_name))
        file1 = FactoryGirl.create(:data_file, user: user)
        @files = [file1, file2]
      end
      
      it "should display the users file ordered by name" do
        get :index
        assigns(:data_files).should == @files
      end 
    end
  end
end
