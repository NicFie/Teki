class GameRoundsController < ApplicationController

  def new
    @game_round = GameRound.new
  end

  def create
    @game_round = GameRound.new(game_round_params)
    @game_round.save
  end

  def index
    @game_rounds = GameRound.where(winner_id: current_user)
  end


  private

  def game_params
    params.require(:game_round).permit(:completion_time, :winner_id, :game_id, :challenge_id)
  end

end
