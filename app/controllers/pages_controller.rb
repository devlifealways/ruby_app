class PagesController < ApplicationController
  attr_accessor :title
  def home
    @title = "Sticky Footer Navbar Template for Bootstrap"
  end

  def contact
    @title = "contact"
  end

  def propos
    @title = "propos"
  end

  def help
    @title = "help"
  end

end
