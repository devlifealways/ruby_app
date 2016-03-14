require 'spec_helper'

describe "LayoutLinks" do
  # render_views

  describe "layout links" do

    describe "when not logged in" do
      it "should have a Sign in link" do
        visit root_path
        response.should have_selector("a[href='#{new_session_path}']")
      end #should have a log in link
    end #when not logged in

    describe "when logged in" do
      #
      before(:each) do
        @user = Factory(:user)
        visit signin_path
        fill_in :email, :with => @user.email
        fill_in :password, :with => @user.password
        click_button
      end
      #
      it "should have a log out link" do
        visit root_path
        response.should have_selector("a[href='#{new_session_path}']")
      end #should have a log out link
      #
      it "should have link to the user's profile" do
        visit root_path
        response.should have_selector("a[href='#{user_path(@user)}']")
      end

    end #when logged in



  end #layout links

end #root describer
