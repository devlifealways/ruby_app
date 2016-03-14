module SessionsHelper

  def current_user= user
    @current_user ||= user_from_remember_token
    #this is why I love ruby: equivalent to --@current_user = @current_user|| user_from_remember_token>
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  # this function will help the user authenticate each time
  # it's been made publicly shown to every controller via the include in the application controller
  def sign_in user
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  private

  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end

end
