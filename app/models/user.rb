# == Schema Information
# Schema version: 20160307154801
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

  def has_password?(txt)
    encrypted_password == encrypt(txt)
  end

  def self.authenticate email,password
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(passo)
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
