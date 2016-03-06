class UsersController < ApplicationController
  attr_accessor :title

  def new
    @title = "sign up"
  end

  def show
    @title = "sign up"
    @user = User.find(params[:id])
  end


end
