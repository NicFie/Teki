class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :dashboard ]

  def home
  end

  def dashboard
    @users_ordered_by_score = User.where('id != 1').order('score DESC').all
    @friendships = Friendship.where(asker_id: current_user)
    as_user_one = current_user.games_as_player_one
    as_user_two = current_user.games_as_player_two
    @latest_battles = [as_user_one, as_user_two].flatten.sort.reverse

    raise
    @game = Game.new
  end
end
