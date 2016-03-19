require 'spec_helper'

describe UsersController do
  render_views

  before(:all) do
    @txt = {:first => "the", :second => "page"}
  end

  describe "GET 'index'" do

    it "should work without any problems" do
      get :index
      response.should redirect_to(signin_path)
      flash[:warning].should =~ /Please log in/i
    end

  end
  #
  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "User not connected" do
      it "should refuse access" do
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "A non administrator user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "As an Administrator" do

      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end

      it "should delete the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should be redirected to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
  end
  #
  describe "When the user is connected" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      second = Factory(:user, :email => "another_bad_guy@gmail.com")
      third  = Factory(:user, :email => "another_bad_guy@hotmail.org")
      @users = [@user, second, third]
      30.times do
        @users << Factory(:user, :email => Factory.next(:email))
      end
    end

    it "should work well" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "#{@txt[:first].capitalize} Users #{@txt[:second]}")
    end

    it "each user name should be putted in a td" do
      get :index
      @users[0..2].each do |user|
        response.should have_selector("td", :content => user.name)
      end
      # @users.each do |user|
      #   response.should have_selector("td", :content => user.name)
      # end
    end

    it "should paginate the users page" do
      get :index
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a", :href => "/users?page=2",
      :content => "2")
      response.should have_selector("a", :href => "/users?page=2",
      :content => "Next")
    end

  end #When the user is connected


  describe "Administrator only" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "Is there really ant Administrator's " do
      @user.should respond_to(:admin)
    end

    it "should not be an administrator by default" do
      @user.should_not be_admin
    end

    it "Should be cappable of becoming an administrator" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "should display micro-messages of the user" do
      mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
      mp2 = Factory(:micropost, :user => @user, :content => "Baz quux")
      get :show, :id => @user
      response.should have_selector("span.content", :content => mp1.content)
      response.should have_selector("span.content", :content => mp2.content)
    end
  end #GET 'show'



  describe "GET 'new'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "It should give the right user" do
      get :show,:id=>@user
      response.should be_success
    end

    it "Should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "Should have the appropriate title" do
      get :new
      response.should have_selector("title",:content=>"#{@txt[:first].capitalize} Sign up #{@txt[:second]}")
    end
  end # the first describe


  describe "POST 'create'" do

    describe "success" do

      before(:each) do
        @attr = { :name => "Phoenix", :email => "phoenix@g.com",
          :password => "things", :password_confirmation => "things" }
        end

        it "should create a user" do
          lambda do
            post :create, :user => @attr
          end.should change(User, :count).by(1)
        end

        it "should redirect the user to his page" do
          post :create, :user => @attr
          response.should redirect_to(user_path(assigns(:user)))
        end

        it "should welcome the user" do
          post :create, :user => @attr
          flash[:success].should =~ /Welcome #{@attr[:name].capitalize} to the ruby world !/i
        end

      end#describe success

      describe "failure" do
        before :each do
          @attr = {:name=>"",:email=>"",:password=>"",:password_confirmation=>""}
        end #before

        it "should not create the user" do
          lambda do
            post :create,:user=>@attr
          end.should_not change(User,:count)
        end #falling to create the user

        it "should have the right title" do
          post :create, :user => @attr
          response.should have_selector("title",:content=>"#{@txt[:first].capitalize} Sign up #{@txt[:second]}")
        end

        it "should send back the page 'new'" do
          post :create, :user => @attr
          response.should render_template('new')
        end

      end #failure
    end #creat post

    describe "GET 'edit'" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "shoud work like a charm" do
        get :edit, :id => @user
        response.should be_success
      end

      it "should have the right title" do
        get :edit, :id => @user
        response.should have_selector("title", :content => "edition profil")
      end

      it "should have a link to change the profil picture" do
        get :edit, :id => @user
        gravatar_url = "http://gravatar.com/emails"
        response.should have_selector("a", :href => gravatar_url,
        :content => "changer")
      end
    end

    describe "edit/update authentication" do

      before(:each) do
        @user = Factory(:user)
      end

      describe "malicious user" do

        it "should not accept 'edit' action" do
          get :edit, :id => @user
          response.should redirect_to(signin_path)
        end

        it "should refuse edit action" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(signin_path)
        end

      end #malicious user

      describe "connected user" do

        before(:each) do
          wrong_user = Factory(:user, :email => "test@gmail.com")
          test_sign_in(wrong_user)
        end

        it "to edit,he should be the right user (the one connected)" do
          get :edit, :id => @user
          response.should redirect_to(root_path)
        end

        it "to update,he should be the right user (the one connected)" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(root_path)
        end

      end

    end #no



  end
