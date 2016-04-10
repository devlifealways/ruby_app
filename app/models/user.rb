# == Schema Information
# Schema version: 20160318204428
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name,:email,:password,:password_confirmation
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence=>true,:length=>{:maximum=>50}
  validates :email, :presence=>true,:format=>{:with=>email_regex},:uniqueness => { :case_sensitive => false }
  validates :password, :presence=>true,
  :confirmation=>true,
  :length=>{:in=>6..40}
  before_save :encrypt_password

  # chapter 11 requirements
  has_many :microposts, :dependent => :destroy

  # chapter 12 requirements
  has_many :relationships, :foreign_key => "follower_id",:dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id",
  :class_name => "Relationship",
  :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
  scope :admin, where(:admin => true)

  def has_password?(txt)
    encrypted_password == encrypt(txt)
  end

  def self.authenticate email,password
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  # true if the current user is following another user
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  # true if someone is following the current user
  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  # pretty simple, destroys the following user
  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  # def feed
  #   Micropost.where("user_id = ?", id)
  # end

  def feed
    Micropost.from_users_followed_by(self)
  end

  private
  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(self.password)
  end

  def encrypt password
    secure_hash "#{salt}--#{password}"
  end

  def make_salt
    secure_hash "#{Time.new.utc}--#{password}"
  end

  def secure_hash hash
    Digest::SHA2.hexdigest hash
  end



end
