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
  end
end
