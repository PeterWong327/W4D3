class UsersController < ApplicationController
  
  before_action :redirect_if_signed_in, only: [:new]
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.new(user_params)

    if @user.save
      login_user!(@user)
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to :new_user
    end
  end
  
  def user_params
    params.require(:user).permit(:username, :password)
  end
end