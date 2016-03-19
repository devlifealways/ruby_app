# require 'spec_helper'
#
# describe "Microposts" do
#
#   before(:each) do
#     user = Factory(:user)
#     visit new_session_path
#     fill_in 'session_email',    :with => user.email
#     fill_in 'session_password', :with => user.password
#     click_button 'session_submit'
#   end
#
#   describe "create action" do
#
#     describe "failure" do
#
#       it "should not create a new micropost" do
#         lambda do
#           visit root_path
#           fill_in :micropost_content, :with => ""
#           click_button
#           response.should render_template('pages/index')
#           response.should have_selector("div.alert alert-danger alert-dismissible")
#         end.should_not change(Micropost, :count)
#       end
#     end #failure
#
#     describe "success" do
#
#       it "should create a new micropost" do
#         content = "Lorem ipsum dolor sit amet"
#         lambda do
#           visit root_path
#           fill_in :micropost_content, :with => content
#           click_button
#           response.should have_selector("span.content", :content => content)
#         end.should change(Micropost, :count).by(1)
#       end
#     end # success
#
#   end # create
#
# end #Microposts
