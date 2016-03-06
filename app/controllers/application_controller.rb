class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logo

  def logo
    "This is a fucking cool logo !"
  end

end
