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


  describe "micro-message associations" do

    before(:each) do
      @user = User.create(@attr)
    end

    it "Should have a 'microposts' attribute" do
      @user.should respond_to(:microposts)
    end
  end


  describe "validation" do

    it "should have a user id" do
      Micropost.new(@attr).should_not be_valid
    end

    it "the content shouldn't be null !" do
      @user.microposts.build(:content => "  ").should_not be_valid
    end

    it "the content cannot be too long !" do
      @user.microposts.build(:content => "a" * 141).should_not be_valid
    end
  end

  describe "access control" do

    it "should refuse the action 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should refuse the action 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end



end
