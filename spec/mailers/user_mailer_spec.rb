require "spec_helper"

describe UserMailer do
  
  describe "invitation_to_share" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
      @folder = FactoryGirl.create(:folder, user: @user)
      @shared_folder = FactoryGirl.create(:shared, user: @user, folder_id: @folder.id)
    end
    
    it "should render successfully" do
      lambda { UserMailer.invitation_to_share(@shared_folder) }.should_not raise_error
    end
    
    describe "render without error" do
      
      before(:each) do
        @invitation = UserMailer.invitation_to_share(@shared_folder)
      end
      
      it "should have a title" do
        @invitation.encoded.should include("#{@shared_folder.user.name} wants to share '#{@shared_folder.folder.name}' folder with you")
      end
      
      it "should have a user name" do
        @invitation.body.should include(@shared_folder.user.name)
      end
      
      it "should have a shared user name" do
        @invitation.body.should include(@shared_folder.folder.name)
      end
      
      it "should have a message" do
        @invitation.body.should include(@shared_folder.message)
      end
      
      it "should have a sign in url" do
        @invitation.body.should include(new_user_session_url)
      end
      
      it "should have a sign up url" do
        @invitation.body.should include(new_user_registration_url)
      end
    end
    
    describe "delivered" do
      
      it "should be added to the delivery queue" do
        lambda { UserMailer.invitation_to_share(@shared_folder).deliver }.should change(ActionMailer::Base.deliveries,:size).by(1)
      end
    end
  end
end
