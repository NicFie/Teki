# frozen_string_literal: true

class FriendChannel < ApplicationCable::Channel
  def subscribed
    @user ||= User.find(params[:id])
    @user.update!(online: true)
    broadcast_status
    stream_for @user
  end

  def unsubscribed
    @user ||= User.find(params[:id])
    @user.update!(online: false)
    broadcast_status
    stop_all_streams
  end

  def broadcast_status
    @user.friends.each do |friend|
      FriendChannel.broadcast_to(
        friend,
        { user_id: @user.id, online: @user.online, command: 'update user status' }
      )
    end
  end
end
