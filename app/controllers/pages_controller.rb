class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    @users_ordered_by_score = User.where('id != 1').order('score DESC').all
    @friendships = Friendship.where(asker_id: current_user).or(Friendship.where(receiver_id: current_user))
    as_user_one = current_user.games_as_player_one.where.not(game_winner: nil)
    as_user_two = current_user.games_as_player_two.where.not(game_winner: nil)
    @latest_battles = [as_user_one, as_user_two].flatten.sort.reverse

    @game = Game.new
  end

  def user_settings

  end
end
