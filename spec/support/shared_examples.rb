shared_examples_for "autheticated user" do
  
  it "should deny access to 'index'" do
    get :index
    response.should redirect_to(new_user_session_path)
  end
  
  it "should deny access to 'show'" do
    get :show, id: 1
    response.should redirect_to(new_user_session_path)
  end
 
  it "should deny access to 'new'" do
    get :new
    response.should redirect_to(new_user_session_path)
  end
  
  it "should deny access to 'create'" do
    post :create, folder: {}
    response.should redirect_to(new_user_session_path)
  end
  
  it "should deny access to 'edit'" do
    get :edit, id: 1
    response.should redirect_to(new_user_session_path)
  end
  
  it "should deny access to 'update'" do
    put :update, id: 1, folder: {}
    response.should redirect_to(new_user_session_path)
  end
  
  it "should deny access to 'destroy'" do
    delete :destroy, id: 1
    response.should redirect_to(new_user_session_path)
  end
end