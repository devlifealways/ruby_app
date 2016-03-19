require 'spec_helper'

describe MicropostsController do

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do

      before(:each) do
        @attr = { :content => "" }
      end

      it "should not create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should_not change(Micropost, :count)
      end

      it "should return the home page" do
        post :create, :micropost => @attr
        response.should render_template('pages/index')
      end
    end #failure

    describe "success" do

      before(:each) do
        @attr = { :content => "Lorem ipsum" }
      end

      it "should create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should change(Micropost, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, :micropost => @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash message" do
        post :create, :micropost => @attr
        flash[:success].should =~ /created/i
      end
    end #success

  end #POST 'create'

  describe "DELETE 'destroy'" do

    describe "user not owning a micropost" do

      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should refuse deleting the message" do
        delete :destroy, :id => @micropost
        response.should redirect_to(root_path)
      end
    end

    describe "the owner of the micropost" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should delete the micropost" do
        lambda do
          delete :destroy, :id => @micropost
        end.should change(Micropost, :count).by(-1)
      end
    end
  end




end
