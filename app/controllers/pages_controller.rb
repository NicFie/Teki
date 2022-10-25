class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :dashboard ]

  def home
  end

  def dashboard
    @users_ordered_by_score = User.where('id != 1').order('score DESC').all
    @friendships = Friendship.where(asker_id: current_user)
    @game = Game.new
  end
end
