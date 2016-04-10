require 'spec_helper'

describe Micropost do

  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "Something to fill within the gaps that's all !" }
  end

  it "should create a new instace of microposts" do
    @user.microposts.create!(@attr)
  end

  describe "User's association" do

    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end

    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end

    it "should have the appropriate user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end


  describe "Micro-message associations" do

    before(:each) do
      @user = User.create(@attr)
    end

    it "Should have a 'microposts' attribute" do
      @user.should respond_to(:microposts)
    end

  end # Micro-message associations


  describe "Validation" do

    it "should have a user id" do
      Micropost.new(@attr).should_not be_valid
    end

    it "the content shouldn't be null !" do
      @user.microposts.build(:content => "  ").should_not be_valid
    end

    it "the content cannot be too long !" do
      @user.microposts.build(:content => "a" * 141).should_not be_valid
    end
  end # describe Validation

  describe "Access control" do

    it "should refuse the action 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should refuse the action 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end # Access control

  describe "from_users_followed_by" do

    before(:each) do
      @other_user = Factory(:user, :email => Factory.next(:email))
      @third_user = Factory(:user, :email => Factory.next(:email))

      @user_post  = @user.microposts.create!(:content => "foo")
      @other_post = @other_user.microposts.create!(:content => "bar")
      @third_post = @third_user.microposts.create!(:content => "baz")

      @user.follow!(@other_user)
    end

    it "Should have a class method from_users_followed_by" do
      Micropost.should respond_to(:from_users_followed_by)
    end

    it "Should contain the following microposts" do
      Micropost.from_users_followed_by(@user).should include(@other_post)
    end

    it "Should contain his microposts" do
      Micropost.from_users_followed_by(@user).should include(@user_post)
    end

    it "Should not include others microposts" do
      Micropost.from_users_followed_by(@user).should_not include(@third_post)
    end
  end #from_users_followed_by








end
