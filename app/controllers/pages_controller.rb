class PagesController < ApplicationController
  attr_accessor :title
  def home
    @title = "Welcome home"
  end

  def contact
    @title = "contact"
  end

  def propos
    @title = "propos"
    @user = User.new
    @user.name = "ROUINEB Hamza"
    @user.email = "rouineb.business@gmail.com"
  end

  def help
    @title = "help"
  end

  def index
    @title = "welcome"
    if signed_in?
      @micropost = Micropost.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end

end
