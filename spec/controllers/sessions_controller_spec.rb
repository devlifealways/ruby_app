require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do
    it "should have the right title" do
      get :new
      response.should have_selector("title",:content=>"Sign in")
    end
  end


  describe "POST 'create'" do

    before (:all) do
      @user = Factory(:user)
      @attr =
      {
        :email =>@user.email,
        :password=>@user.password
      }
    end

    describe "Invalid sign in !" do
      before (:all) do
        @attr_local =
        {
          :email =>"a@a.a",
          :password=>"things",
        }
      end
      it "should redirect to the new page !" do
        post :create,:session => @attr_local
        response.should render_template('new')
      end

      it "should contain error messages" do
        post :create, :session => @attr_local
        response.should have_selector('div',:class=>'alert alert-danger alert-dismissible space')
      end

      it "should sign in the user after the creation" do
        post :create, :user => @attr_local
        controller.should be_signed_in
      end

    end # invalid sign in !

    describe "correct email and password" do

      it "should recognize the user !" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end #should recognize the user !

      it "should redirect the given user to his page" do
        post :create,:session => @attr
        response.should redirect_to user_path(@user)
      end #should redirect the given user to his page

    end #correct email and password

    describe "DELETE 'destroy'" do

      it "should sign out the user" do
        test_sign_in(Factory(:user))
        delete :destroy
        controller.should_not be_signed_in
        response.should redirect_to(root_path)
      end
    end


  end

end
