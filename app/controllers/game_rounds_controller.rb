class GameRoundsController < ApplicationController

  def new
    @game_round = GameRound.new
    authorize @game_round
  end

  def create
    @game_round = GameRound.new(game_round_params)
    authorize @game_round
    @game_round.save
  end

  def index
    @game_rounds = GameRound.where(winner_id: current_user)
    authorize @game_round
  end


  def update
    @game_round = GameRound.find(params[:id])
    @game_round.update(game_params)
    @game_round.save!
    skip_authorization

    respond_to do |format|
      format.js #add this at the beginning to make sure the form is populated.
    end
  end

  private

  def game_params
    params.require(:game_round).permit(:completion_time, :winner_id, :game_id, :challenge_id, :player_one_code, :player_two_code)
  end

end
