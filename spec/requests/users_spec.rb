require 'spec_helper'

describe "Users" do

  describe "signup" do
    
    describe "failure" do
      
      it "should nout create a new user" do
        lambda do
          visit new_user_registration_path
          fill_in :name, with: ''
          fill_in :email, with: ''
          fill_in :password, with: ''
          fill_in :user_password_confirmation, with: ''
          click_button
          response.should have_selector('div#error_explanation', content: 'errors prohibited')
          response.should render_template('devise/registrations/new')
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do
      
      it "should create a new user" do
        lambda do
          visit new_user_registration_path
          fill_in :name, with: 'Test User'
          fill_in :email, with: 'test.user@sharebox.com'
          fill_in :password, with: 'foobar'
          fill_in :user_password_confirmation, with: 'foobar'
          click_button
          response.should have_selector('div#flash_notice', content: 'Welcome!')
          response.should render_template('home/index')
        end.should change(User, :count).by(1)
      end
    end
  end
  
  describe "sign in/out" do
    
    describe "failures" do
      
      it "should not sign a user in" do
        visit new_user_session_path
        fill_in :email, with: ''
        fill_in :password, with: ''
        click_button
        response.should have_selector('div#flash_alert', content: 'Invalid')
        response.should render_template('devise/sessions/new')
      end
    end
    
    describe "success" do
      it "should sign a user in and out" do
        user = FactoryGirl.create(:user)
        test_sign_in(user)
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end
  
  describe "Upload files" do
    
    before(:each) do
      user = FactoryGirl.create(:user)
      test_sign_in(user)
    end
    
    describe "success" do
      
      it "should upload a new file" do
        click_link "Upload"
        attach_file :data_file_uploaded_file, "#{Rails.root}/spec/fixtures/images/test.jpg", "image/jpeg"
        click_button
        #response.should redirect_to()
        response.should have_selector('div#flash_notice', content: 'Successfully')
      end
    end
  end
end