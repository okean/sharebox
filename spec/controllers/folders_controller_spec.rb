require 'spec_helper'

describe FoldersController do
  render_views
  
  before(:each) do
    @user = FactoryGirl.create(:user)
  end
  
  describe "access control" do
    
    it_should_behave_like "autheticated user"
  end
  
  describe "GET 'index'" do
    
    context "when signed in" do
      
      before(:each) do
        sign_in @user
        @folder = FactoryGirl.create(:folder, user: @user)
      end
      
      it "should render 'index' template" do
        get :index
        response.should render_template('folders/index')
      end
      
      it "should display user's folders" do
        get :index
        response.should have_selector('td', content: @folder.name)
      end
    end
  end
  
  describe "GET 'show'" do
    
    context "when signed in" do
      
      before(:each) do
        sign_in @user
        @folder = FactoryGirl.create(:folder, user: @user)
      end
      
      it "should render 'show' template" do
        get :show, id: @folder
        response.should render_template('folders/show')
      end
    end
  end
  
  describe "GET 'new'" do
    
    context "when signed in" do
      
      before(:each) do
        sign_in @user
      end
      
      it "should render 'new' template" do
        get :new
        response.should render_template('folders/new')
      end
      
      it "should create an instance for a root folder" do
        get :new
        assigns(:folder).parent_id.should be_nil
      end
      
      it "should create an instance for a children folder" do
        folder = FactoryGirl.create(:folder, user: @user)
        get :new, folder_id: folder
        assigns(:folder).parent_id.should == folder.id
      end
    end
  end
  
  describe "POST 'create'" do
    
    context "when signed in" do
      
      before(:each) do
        sign_in @user
      end
      
      describe "failure" do
        
        before(:each) do
          @attr = { name: "" }
        end
        
        it "should not create a folder" do
          lambda do
            post :create, folder: @attr
          end.should_not change(Folder, :count)
        end
        
        it "should render 'new' template" do
          post :create, folder: @attr
          response.should render_template('folders/new')
        end
      end
      
      describe "success" do
        
        before(:each) do
          @attr = { name: "test_folder" }
        end
        
        it "should create a new folder" do
          lambda do
            post :create, folder: @attr
          end.should change(Folder, :count).by(1)
        end
        
        it "should redirect to Home page on creating root folders" do
          post :create, folder: @attr
          response.should redirect_to root_path
        end
        
        it "should redirect to parent folder on creating children folder" do
          post :create, folder: @attr.merge({ parent_id: 1 })
          response.should redirect_to browse_path(1)
        end
        
        it "should have a flash message" do
          post :create, folder: @attr
          flash[:notice] =~ /Successfully created folder/i
        end
      end
    end
  end

  describe "GET 'edit'" do
    
    context "when signed in" do
      
      before(:each) do
        sign_in @user
        @folder = FactoryGirl.create(:folder, user: @user)
      end
      
      it "should render 'edit' template" do
        get :edit, id: @folder
        response.should render_template('folders/edit')
      end
    end
  end

  describe "PUT 'update'" do
    
    context "when signed in" do
      
      before(:each) do
        sign_in @user
        @folder = FactoryGirl.create(:folder, user: @user)
      end
      
      describe "failure" do
        
        before(:each) do
          @attr = { name: "" }
        end
        
        it "should render 'edit' template" do
          put :update, id: @folder, folder: @attr
          response.should render_template('folders/edit')
        end
      end
      
      describe "success" do
        
        before(:each) do
          @attr = { name: "new_name" }
        end
        
        it "should update the folder's name" do
          put :update, id: @folder, folder: @attr
          @folder.reload
          @folder.name.should == @attr[:name]
        end
        
        it "should redirect to folder page" do
          put :update, id: @folder, folder: @attr
          response.should redirect_to(folder_url(assigns[:folder]))
        end
        
        it "should have a flash message" do
          put :update, id: @folder, folder: @attr
          flash[:notice].should =~ /uccessfully updated folder/i
        end
      end
    end
  end

  describe "DELETE 'destroy'" do
    
    context "when signed in" do
      
      before(:each) do
        sign_in @user
      end
      
      describe "for an unauthorized user" do
        
        it "should not delete a folder" do
          lambda do
           delete :destroy, id: 2
          end.should_not change(Folder, :count)
        end
        
        it "should redirect to root path" do
          delete :destroy, id: 2
          response.should redirect_to root_path
        end
      end
      
      describe "for an authorized user" do
        
        before(:each) do
          @folder = FactoryGirl.create(:folder, user: @user)
        end
        
        it "should delete folder" do
          lambda do
            delete :destroy, id: @folder
          end.should change(Folder, :count).by(-1)
        end
        
        it "should redirect to folders path" do
          delete :destroy, id: @folder
          response.should redirect_to(folders_path)
        end
        
        it "should have a flash message" do
          delete :destroy, id: @folder
          flash[:notice] =~ /Successfully destroyed folder/i
        end
      end
    end
  end
end
