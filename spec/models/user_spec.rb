require 'spec_helper'



describe User do
  before (:all) do
    @attr = {:name=>"Example User",:email =>"a@a.a"}
  end

  it "Each user have a valid attribute" do
    User.create!(@attr)
  end

  it "The name should not be emoty" do
    bad_guy = User.new(@attr.merge(:name => ""))
    bad_guy.should_not be_valid
    #expect(bad_guy).not_to be_valid
  end

  it "The Email should not be empty" do
    bad_guy = User.new(@attr.merge(:email=>""))
    bad_guy.should_not be_valid
  end

  it "The name should be less than 50 char" do
    to_much = "b"*51
    bad_guy = User.new(@attr.merge(:name=>to_much))
    bad_guy.should_not be_valid
  end

  it "These emails should be rejected" do
    adresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    adresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "Every user should have a unique email" do
    #This is a far more complex example, wich verify the sensitivity of input
    # saves a user in the database with given attributes.
    User.create!(@attr.merge(:email=>@attr[:email].downcase))
    #I know that the bag ! is annoying but to make sure that the test works as planned !
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end


end
