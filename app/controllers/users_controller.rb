class UsersController < ApplicationController
  # skip_authorization only: [:send_invitation]
  def index
    @current_user = current_user
    @requests = current_user.pending_invitations
    @users = policy_scope(User)
  end

  def show
    @user = User.find(params[:id])
    @requests = current_user.pending_invitations
    authorize @user
    # @friendship = current_user.friendship_with(@user)
  end

  def send_game_invitation
    user = User.find(params[:id])
    FriendsChannel.broadcast_to(user, { command: 'checking' })
    skip_authorization
  end

  def send_invitation
    @invitation = current_user.send_invitation(User.find(params[:id]))
    if @invitation.save!
      redirect_to dashboard_path
    else
      raise
    end
    skip_authorization
  end

  def accept_invitation
    @invitation = Invitation.find(params[:id])
    @invitation.confirmed = true
    if @invitation.save!
      redirect_to dashboard_path
    else
      raise
    end
    skip_authorization
  end

  def reject_invitation
    @invitation = Invitation.find(params[:id])
    @invitation.destroy
    redirect_to dashboard_path
    skip_authorization
  end
end
