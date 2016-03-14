require 'spec_helper'

describe "Users" do
  describe "GET /users" do

    it "should not create a new user" do
      lambda do
        visit new_user_path
        fill_in 'user_name', :with=> "wrong"
        fill_in 'user_email', :with=> "a@g.c"
        fill_in 'user_password', :with=> "123"
        fill_in 'user_password_confirmation', :with => "123"
        click_button "user_submit"
        response.should render_template('users/new')
        response.should have_selector('div',:class=>'alert alert-danger alert-dismissible')
      end.should_not change(User, :count)
    end

    it "should create a new user" do
      lambda do
        visit new_user_path
        fill_in 'user_name', :with=> "Phoenix"
        fill_in 'user_email', :with=> "Phoenix.test@test.com"
        fill_in 'user_password', :with=> "123456"
        fill_in 'user_password_confirmation', :with => "123456"
        click_button "user_submit"
        response.should render_template('users/new')
      end.should change(User,:count).by(1)
    end

    it 'the form should have the name input' do
      visit new_user_path
      response.should render_template('users/new')
      response.should have_xpath("//input[@id='user_name']")
    end

    it 'the form should have the email input' do
      visit new_user_path
      response.should render_template('users/new')
      response.should have_xpath("//input[@id='user_email']")
    end

    it 'the form should have the password input' do
      visit new_user_path
      response.should render_template('users/new')
      response.should have_xpath("//input[@id='user_password']")
    end

    it 'the form should have the name input' do
      visit new_user_path
      response.should render_template('users/new')
      response.should have_xpath("//input[@id='user_password_confirmation']")
    end


  end

  describe "sign in/sign out" do

    it "should be rejected at first glance" do
      visit signin_path
      fill_in "session_email", :with => ""
      fill_in "session_password", :with => ""
      click_button "session_submit"
      response.should have_xpath("//div[@class='alert alert-danger alert-dismissible space']")
    end

    it "should give access to user's profile " do
      user = Factory(:user)
      visit signin_path
      fill_in "session_email", :with => user.email
      fill_in "session_password", :with => user.password
      click_button "session_submit"
      controller.should be_signed_in
      click_link "signout"
      controller.should_not be_signed_in
    end


  end

end
