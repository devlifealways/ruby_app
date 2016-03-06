class UsersController < ApplicationController
  attr_accessor :title

  def new
    @title = "sign up"
  end

end
