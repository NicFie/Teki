class UsersController < ApplicationController

  def index
    @users = policy_scope(User)
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    # authorize @user
    @friendship = current_user.friendship_with(@user)
  end

end
