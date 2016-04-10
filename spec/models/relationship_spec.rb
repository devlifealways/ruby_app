require 'spec_helper'

describe Relationship do

  before(:each) do
    @follower = Factory(:user)
    @followed = Factory(:user, :email => Factory.next(:email))

    @relationship = @follower.relationships.build(:followed_id => @followed.id)
  end

  it "should create a new instance with valid attributes" do
    #! to throw an exception in case there is a problem
    @relationship.save!
  end # new instance with valid ...


  describe "Following methods" do

    before(:each) do
      @relationship.save
    end

    it "should have an attribut follower" do
      @relationship.should respond_to(:follower)
    end

    it "should have the right follower" do
      @relationship.follower.should == @follower
    end

    it "should have a followed attribut" do
      @relationship.should respond_to(:followed)
    end

    it "should have the right followed" do
      @relationship.followed.should == @followed
    end
  end # describe Following methods


  describe "Validations" do

    it "should ask for follower_id" do
      @relationship.follower_id = nil
      @relationship.should_not be_valid
    end

    it "should ask for followed_id" do
      @relationship.followed_id = nil
      @relationship.should_not be_valid
    end
  end #describe Validations



end
