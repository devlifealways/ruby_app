class SessionsController < ApplicationController

  def new
    @title = "sign in"
  end

  def create
    # params[:session][:email] = "a@a.a"
    # params[:session][:password] = "123"
    # user = User.authenticate("a@a.a",123)
    user = User.authenticate(params[:session][:email],params[:session][:password])
    if user.nil?
      @title = "sign in"
      flash[:danger] = "Email/Password are wrong, please make sure of your confidentials !"
      render :new
    else
      sign_in user
      redirect_to user
    end

  end

  def destroy
    sign_out
    redirect_to root_path
  end


end
