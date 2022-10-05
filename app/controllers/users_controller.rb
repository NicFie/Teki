class UsersController < ApplicationController
  def index
    @current_user = current_user
    @users = policy_scope(User)
  end

  def show
    @user = User.find(params[:id])
    authorize @user
    @friendship = current_user.friendship_with(@user)
  end
end
