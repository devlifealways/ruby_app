require 'spec_helper'

describe PagesController do
  render_views

  # before(:all) do
  #   @txt = {:title => "title",:first => "the", :second => "page"}
  # end
  #
  # describe "GET 'home'" do
  #   it "should be successful" do
  #     get 'home'
  #     response.should be_success
  #   end
  #   it "should have the right title" do
  #     get 'home'
  #     response.should have_selector("title",:content=>"#{@txt[:first].capitalize} Home #{@txt[:second]}")
  #   end
  # end
  #
  # describe "GET 'contact'" do
  #   it "should be successful" do
  #     get 'contact'
  #     response.should be_success
  #   end
  #   it "should have the right contact" do
  #     get 'contact'
  #     response.should have_selector("title",:content=>"#{@txt[:first].capitalize} Contact #{@txt[:second]}")
  #   end
  # end
  #
  # describe "GET 'propos'" do
  #   it "should be successful" do
  #     get 'propos'
  #     response.should be_success
  #   end
  #   it "should have the right title" do
  #     get 'propos'
  #     response.should have_selector("title",:content=>"#{@txt[:first].capitalize} Propos #{@txt[:second]}")
  #   end
  # end
  #
  # describe "GET 'help'" do
  #   it "should be successful" do
  #     get 'help'
  #     response.should be_success
  #   end
  #   it "should have the right title" do
  #     get 'help'
  #     response.should have_selector("title",:content=>"#{@txt[:first].capitalize} Help #{@txt[:second]}")
  #   end
  # end
  # describe "GET 'index'" do
  #   it "should be successful" do
  #     get 'index'
  #     response.should be_success
  #   end
  # end


  before(:each) do
    @base_titre = "Welcome to the Ruby world !"
  end

  describe "GET 'home'" do

    describe "When not identified ?" do

      before(:each) do
        get :home
      end

      it "should be success" do
        response.should be_success
      end #

      it "should have the right title" do
        response.should have_selector("title",
        :content => "#{@base_titre} | Home")
      end #

    end # When not identified ?

    describe "Identified when ?" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end

      it "should have the right followers & following accounts " do
        get :home
        response.should have_selector("a", :href => following_user_path(@user),
        :content => "0 auteur suivi")
        response.should have_selector("a", :href => followers_user_path(@user),
        :content => "1 lecteur")
      end # Identified when ?

    end # describe

  end

end
