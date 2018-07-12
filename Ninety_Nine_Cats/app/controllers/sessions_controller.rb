class SessionsController < ApplicationController
  
  before_action :redirect_if_signed_in, only: [:new]
  
  def new  #log-in page
    @user = User.new
  end
  
  def create # receives Post request from new to log in user
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])
    if @user
      login_user!(@user)
    else
      flash[:errors] = ["Invalid username + password combo"]
      redirect_to :new_session
    end
  end
  
  def destroy # logs out the user
    current_user.reset_session_token! if current_user
    session[:session_token] = nil
    redirect_to :new_session
  end
  
end
