class UsersController < ApplicationController
  attr_accessor :title
  before_filter :authenticate, :only => [:index,:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def index
    @title = "Users"
    @users = User.paginate(:page => params[:page])
    # each user should not see him self among the users, it's a little bit akward
    # and he could delete himeself accidentaly .. happend to me !
    @users.delete_if{|i|i==current_user} unless @users.empty?
  end

  def new
    @title = "sign up"
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
    @users = @user.microposts.paginate(:page => params[:page])
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

  def edit
    @title = "Edit the profile"
    # @user = current_user
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profil updated"
      redirect_to @user
    else
      @titre = "profil edition"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted !"
    redirect_to users_path
  end


  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless !current_user.nil? and current_user.admin?
  end

end
