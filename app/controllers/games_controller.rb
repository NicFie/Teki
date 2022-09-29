class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.player_one = current_user
    @game.player_two = current_user

    rounds = @game.round_count

    while rounds.positive?
      random = Challenge.all.size
      challenge = Challenge.find(id: rand(1..random))
      GameRound.new(game_id: @game.id, challenge_id: challenge)
    end
    
    @game.save!

    redirect_to game_path(@game)
  end

  def show
    @game = Game.find(params[:id])
    raise
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
