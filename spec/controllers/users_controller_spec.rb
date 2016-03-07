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
      get 'new'
      response.should be_success
    end

    it "Should have the appropriate title" do
      get 'new'
      response.should have_selector("title",:content=>"#{@txt[:first].capitalize} Sign up #{@txt[:second]}")
    end
  end # the first describe



end
