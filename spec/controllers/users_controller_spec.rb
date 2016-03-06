require 'spec_helper'

describe UsersController do
  render_views

  before(:each) do
    @txt = {:first => "the", :second => "page"}
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "Should have the appropriate title" do
      get 'new'
      response.should have_selector("title",:content=>"#{@txt[:first].capitalize} Sign up #{@txt[:second]}")
    end

  end

end
