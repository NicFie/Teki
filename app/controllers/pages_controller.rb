class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def dashboard
    @users_ordered_by_score = User.where('id != 1').order('score DESC').all
    @friends = current_user.friends.order('updated_at DESC')
    users_games = Game.where(
                        player_one_id: current_user.id).where.not(game_winner: nil)
                      .or(Game.where(
                        player_two_id: current_user.id).where.not(game_winner: nil))
                      .order(updated_at: :desc)
    @latest_battles = users_games.to_a
    @requests = current_user.pending_invitations
    @with_friend = false
    @game = Game.new
  end

  def user_settings
    @requests = current_user.pending_invitations
  end
end
