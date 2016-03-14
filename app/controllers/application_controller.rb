class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  helper_method :logo

  #I'm just amazed by the RESTful paradigm !
  # testing the below helper method
  def logo
    "This is a cool logo !"
  end

end
