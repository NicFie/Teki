class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.player_one = current_user
    @game.player_two = current_user
    @game.save!

    add_rounds_and_challenges(@game.id)
  end

  def add_rounds_and_challenges(id)
    game = Game.find(id)
    rounds = game.round_count
    all_challenges = Challenge.all.to_a

    while rounds.positive?
      challenge = all_challenges[rand(0..all_challenges.size - 1)]
      GameRound.create!(game_id: game.id, challenge_id: challenge.id, winner: current_user)
      all_challenges.delete_at(all_challenges.index(challenge))
      rounds -= 1
    end

    redirect_to game_path(game)
  end

  def show
    @game = Game.find(params[:id])
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.update(game_params)
  end


  private

  def game_params
    params.require(:game).permit(:player_one_id, :player_two_id, :round_count)
  end
end
