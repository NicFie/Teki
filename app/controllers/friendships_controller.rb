class FriendshipsController < ApplicationController
  def index
    @friendships = policy_scope(Friendship)
    @friendships = Friendship.where(asker_id: current_user)
    @users = User.all
  end

  def show
    @friendship = Friendship.find(params[:id])
    authorize @friendship
  end

  def new
    @friendship = Friendship.new
    authorize @friendship
  end

  def create
    @friendship = Friendship.new
    authorize @friendship
    @friendship.asker = current_user
    @friendship.receiver = User.find(params[:user_id])
    if @friendship.save
      redirect_to friendships_path
    else
      render root_path
    end
  end

  def edit
    @friendship = Friendship.find(params[:id])
    authorize @friendship
  end

  def update
    @friendship = Friendship.find(params[:id])
    authorize @friendship
    @friendship.update(friendship_params)
    if friendship.save
      redirect_to friendships_path
    else
      render :update, status: :unprocessable_entity
    end
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    authorize @friendship
    @friendship.destroy
    redirect_to friendships_path, status: :see_other
  end

  private

  def friendship_params
    params.require(:friendship).permit(:status)
  end
end
