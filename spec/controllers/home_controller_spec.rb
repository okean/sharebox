require 'spec_helper'

describe HomeController do
  render_views
  
  describe "access control" do
    
    it "should deny access to 'browse'" do
      get :browse, folder_id: 1
      response.should redirect_to(new_user_session_path)
    end
    
    it "should deny access to 'share'" do
      post :share
      response.should redirect_to(new_user_session_path)
    end
  end

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
        @user = FactoryGirl.create(:user)
        sign_in @user
      end
      
      it "should display the users file ordered by name" do
        file2 = FactoryGirl.create(:data_file, user: @user,
                            uploaded_file: FactoryGirl.generate(:file_name))
        file1 = FactoryGirl.create(:data_file, user: @user)
        get :index
        assigns(:data_files).should == [file1, file2]
      end
      
      it "should display the users folders ordered by name" do
        folder2 = FactoryGirl.create(:folder, name: "b_folder", user: @user)
        folder1 = FactoryGirl.create(:folder, name: "a_folder", user: @user)
        get :index
        assigns(:folders).should == [folder1, folder2]
      end
      
      it "should only display root folders" do
        folder1 = FactoryGirl.create(:folder, name: "a_folder", user: @user)
        folder2 = FactoryGirl.create(:folder, name: "b_folder", user: @user,
                                         parent_id: folder1.id)
        get :index
        assigns(:folders).should == [folder1]
      end
      
      it "should only display files that don't have a folder" do
        folder1 = FactoryGirl.create(:folder, name: "a_folder", user: @user)
        file1 = FactoryGirl.create(:data_file, user: @user)
        file2 = FactoryGirl.create(:data_file, user: @user,
                  uploaded_file: FactoryGirl.generate(:file_name), folder_id: folder1.id)
        get :index
        assigns(:data_files).should == [file1]
      end
    end
  end
  
  describe "POST 'share'" do
    
    context "when signed in" do
      
      before(:each) do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end
      
      it "should share a folder" do
        lambda do
          xhr :post, :share, email_addresses: "shared@sharebox.com", folder_id: 1
          response.should be_success
        end.should change(SharedFolder, :count).by(1)
      end
    end
  end
  
  describe "GET 'browse'" do
    
    context "when signed in" do
      
      before(:each) do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end
      
      describe "for an unauthorized user" do
        
        it "should redirect root path" do
          get :browse, folder_id: 2
          response.should redirect_to root_path
        end
        
        it "should have a flash message" do
          get :browse, folder_id: 2
          flash[:error] =~ /Don't be cheeky! Mind your own folders!/i
        end
      end
      
      describe "for an authorized user" do
        
        before(:each) do
          @folder = FactoryGirl.create(:folder, user: @user)
        end
        
        it "should render 'index' page" do
          get :browse, folder_id: @folder
          response.should render_template('index')
        end
        
        it "should display folder's subfolders" do
          @subfolder = FactoryGirl.create(:folder, user: @user, parent_id: @folder.id)
          get :browse, folder_id: @folder
          response.should have_selector('a', content: @subfolder.name,
                                                href: browse_path(@subfolder))
        end
        
        it "should display folder's files" do
          @file = FactoryGirl.create(:data_file, user: @user, folder_id: @folder.id)
          get :browse, folder_id: @folder
          response.should have_selector('a', content: @file.file_name,
                                                href: download_path(@file))
        end
      end
    end
  end
end