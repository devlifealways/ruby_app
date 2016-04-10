require 'spec_helper'

describe User do
  before (:each) do
    @attr =
    {
      :name=>"Example User",
      :email =>"a@a.a",
      :password=>"things",
      :password_confirmation=>"things"
    }
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

  describe "Password validation : " do

    it "The password should not be empty" do
      User.new(@attr.merge(:password=>"",:confirm=>"")).should_not be_valid
    end

    it "Password should not be too long" do
      to_much = "a"*41
      bad_guy = User.new(@attr.merge({:password=>to_much,:password_confirmation=>to_much}))
      bad_guy.should_not be_valid
    end

    it "The password should be identical" do
      bad_guy = User.new(@attr.merge({:password_confirmation=>"invalid"}))
      bad_guy.should_not be_valid
    end

  end # password's section

  describe "Password encryption : " do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "Should have an encrypted password" do
      @user.should respond_to(:encrypted_password)
    end

    it "Encrypted password should not be empty" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password method" do
      it "should have the same crypted password" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should not have the same password" do
        @user.has_password?("invalid").should be_false
      end
    end #has_password method

    describe "Testing the authenticate method" do

      it "Wrong password given" do
        bad_guy = User.authenticate(@attr[:email],"wrong")
        bad_guy.should be_nil
      end

      it "Wrong email given" do
        bad_guy = User.authenticate("wrong",@attr[:password])
        bad_guy.should be_nil
      end

      it "correct email/password given" do
        good_guy = User.authenticate(@attr[:email],@attr[:password])
        good_guy.should == @user
      end

    end #Testing the authenticate method

  end #Password encryption :

  describe "microposts associations" do

    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have an attribute `microposts`" do
      @user.should respond_to(:microposts)
    end

    it "should have the right micro-messags well ordered" do
      @user.microposts.should == [@mp2, @mp1]
    end

    it "should destroy all the micro-messages associated with the user" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    it "should have a function called `feed`" do
      @user.should respond_to(:feed)
    end

    it "should have the microposts of the user" do
      @user.feed.include?(@mp1).should be_true
      @user.feed.include?(@mp2).should be_true
    end

    it "only the microposts of the given user" do
      mp3 = Factory(:micropost,
      :user => Factory(:user, :email => Factory.next(:email)))
      @user.feed.include?(mp3).should be_false
    end

    describe "Feed status" do

      it "Should have a feed" do
        @user.should respond_to(:feed)
      end

      it "Should contain also the user microposts" do
        @user.feed.should include(@mp1)
        @user.feed.should include(@mp2)
      end

      it "Should not contain ohters microposts" do
        mp3 = Factory(:micropost,
        :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.should_not include(mp3)
      end

      it "Should contain followings microposts" do
        followed = Factory(:user, :email => Factory.next(:email))
        mp3 = Factory(:micropost, :user => followed)
        @user.follow!(followed)
        @user.feed.should include(mp3)
      end

    end # Feed status

  end #microposts associations

  describe "relationships" do

    before(:each) do
      @user = User.create!(@attr)
      @followed = Factory(:user)
    end

    it "should have a relashionships method" do
      @user.should respond_to(:relationships)
    end # relashionships method

    it "should have a following? method" do
      @user.should respond_to(:following?)
    end

    it "should have a follow! method" do
      @user.should respond_to(:follow!)
    end

    it "should follow another user" do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end

    it "should include the user (his following) in the list of his followings" do
      @user.follow!(@followed)
      @user.following.should include(@followed)
    end

    it "should have an unfollow! method" do
      @followed.should respond_to(:unfollow!)
    end

    it "should stop following another user" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.should_not be_following(@followed)
    end

    it "should have a reverse_relationship method" do
      @user.should respond_to(:reverse_relationships)
    end

    it "should have a followers method" do
      @user.should respond_to(:followers)
    end

    it "should have the followers int he followers table" do
      @user.follow!(@followed)
      @followed.followers.should include(@user)
    end


  end # describe relashionships

end
