class UsersController < ApplicationController
  attr_accessor :title

  def new
    @title = "sign up"
    @user = User.new
  end

  def show
    # flash[:failure] = "There seems to be a problem !"
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome #{@user.name.capitalize} to the ruby world !"
      redirect_to @user
    else
      @title = "sign up"
      render 'new'
    end
  end

end
