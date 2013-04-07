require 'spec_helper'

describe DataFilesController do
  render_views

  before(:each) do
    @user = FactoryGirl.create(:user)
  end
  
  describe "access control" do
    
    it_should_behave_like "autheticated user"
    
    it "should deny access to 'get'" do
      get :get, id: 1
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'index'" do
    
    context "when signed in" do
      
      before(:each) do
        sign_in @user
        @file = FactoryGirl.create(:data_file, user: @user)
      end
      
      it "should render 'index' template" do
        get :index
        response.should render_template('data_files/index')
      end
      
      it "should display user's files" do
        get :index
        response.should have_selector("td a", content: 'test.jpg',
                                              href: '/data_files/get/1')
      end
    end
  end
  
  describe "GET 'show'" do
    
    context "when signed in" do
      
      before(:each) do
        sign_in @user
        @file = FactoryGirl.create(:data_file, user: @user)
      end
      
      it "should render show template" do
        get :show, id: @file.id
        response.should render_template('data_files/show')
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
        response.should render_template('data_files/new')
      end
      
      it "should create a file instance" do
        get :new
        assigns(:data_file).folder_id.should be_nil
      end
      
      it "should create a nested file instance" do
        folder = FactoryGirl.create(:folder, user: @user)
        get :new, folder_id: folder
        assigns(:data_file).folder_id.should == folder.id
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
          @attr = { }
        end
        
        it "should render 'new' template" do
          post :create, data_file: @attr
          response.should have_selector('div.error_messages h2', content: 'Invalid Fields')
          response.should render_template('data_files/new')
        end
        
        it "should not create a file" do
          lambda do
            post :create, data_file: @attr
          end.should_not change(DataFile, :count)
        end
      end
      
      describe "success" do
        
        before(:each) do
          @attr = { uploaded_file: fixture_file_upload("/images/test.jpg", 'image/jpg') }
        end
        
        it "should create a file" do
          lambda do
            post :create, data_file: @attr
          end.should change(DataFile, :count)
        end
        
        it "should redirect to home page if there is no parent folder" do
          post :create, data_file: @attr
          response.should redirect_to root_path
        end
        
        it "should redirect to parent folder" do
          folder = FactoryGirl.create(:folder, user: @user)
          post :create, data_file: @attr.merge({ folder_id: folder.id })
          response.should redirect_to browse_path(folder)
        end
        
        it "should have a success message" do
          post :create, data_file: @attr
          flash[:notice].should =~ /successfully created data file/i
        end
      end
    end
  end

  describe "GET 'edit'" do
    
    context "when signed in" do
      
      before(:each) do
        sign_in @user
        @file = FactoryGirl.create(:data_file, user: @user)
      end
      
      it "should render 'edit' template" do
        get :edit, id: @file
        response.should render_template('data_files/edit')
      end
    end
  end

  describe "PUT 'update'" do
    
    context "when signed in" do
      
      before(:each) do
        sign_in @user
        @file = FactoryGirl.create(:data_file, user: @user)
        @attr = { uploaded_file: fixture_file_upload("/images/update.jpg", 'image/jpg') }
      end
        
      it "should update user's file" do
        put :update, id: @file, data_file: @attr
        @file.reload
        @file.file_name.should == 'update.jpg'
      end
      
      it "should redirect to file page" do
        put :update, id: @file, data_file: @attr
        response.should redirect_to data_file_url(assigns[:data_file])
      end
      
      it "should have a success message" do
        put :update, id: @file, data_file: @attr
        flash[:notice].should =~ /successfully updated data file/i
      end
    end
  end

  describe "DELETE 'destroy'" do
    
    context "when signed in" do
      
      before(:each) do
        sign_in @user
      end
      
      describe "for an unauthorized user" do
        
        it "should not delete a file" do
          lambda do
           delete :destroy, id: 2
          end.should_not change(DataFile, :count)
        end
        
        it "should redirect to root path" do
          delete :destroy, id: 2
          response.should redirect_to root_path
        end
      end
      
      describe "for an authorized user" do
        
        before(:each) do
          @file = FactoryGirl.create(:data_file, user: @user)
        end
        
        it "should delete folder" do
          lambda do
            delete :destroy, id: @file
          end.should change(DataFile, :count).by(-1)
        end
        
        it "should redirect to home page if there is no parent folder" do
          delete :destroy, id: @file
          response.should redirect_to root_path
        end
        
        it "should redirect to parent folder" do
          folder = FactoryGirl.create(:folder, user: @user)
          @file.folder_id = folder.id
          @file.save
          delete :destroy, id: @file
          response.should redirect_to browse_path(folder)
        end
        
        it "should have a flash message" do
          delete :destroy, id: @file
          flash[:notice] =~ /Successfully deleted file/i
        end
      end
    end
  end
  
  describe "GET 'download' " do
    
    context "when signed in" do
      
      before(:each) do
        sign_in @user
        @file = FactoryGirl.create(:data_file, user: @user)
      end
     
      describe "for an unauthorized user" do
        
        it "should redirect to data_files path" do
          get :get, id: 2
          response.should redirect_to(data_files_path)
        end
        
        it "should have a flash message" do
          get :get, id: 2
          flash[:error].should =~ /Don't be cheeky! Mind your own files/i
        end
      end
      
      describe "for an authorized user" do
        
        it "should return user's file" do
          @controller.should_receive(:send_file).with(@file.uploaded_file.path,
                                    { type: @file.uploaded_file_content_type,
                                    x_sendfile: true }).and_return { @controller.render nothing: true }
          get :get, id: @file
        end
      end
    end
  end
end