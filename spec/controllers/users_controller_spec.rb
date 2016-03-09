require 'spec_helper'

describe UsersController do
  render_views

  before(:all) do
    @txt = {:first => "the", :second => "page"}
  end

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
  end
