class ApplicationController < ActionController::Base
  helper_method :current_user
  protect_from_forgery with: :exception
  
  def current_user
    return nil unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token])
  end
  
  def login_user!(user)
    session[:session_token] = user.reset_session_token!
    redirect_to :cats
  end

  def redirect_if_signed_in
    redirect_to :cats if current_user
  end

end
