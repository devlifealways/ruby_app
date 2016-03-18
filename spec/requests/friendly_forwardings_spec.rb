require 'spec_helper'

describe "FriendlyForwardings" do

  describe "GET /friendly_forwardings" do

    it "should redirect to the authentication page directly" do
      user = Factory(:user)
      visit edit_user_path(user)
      # fill_in "user_email"    , :with => user.email
      # fill_in "user_password" , :with => user.password
      # click_button "user_submit"
      response.should render_template('sessions/new')
    end

  end
end
