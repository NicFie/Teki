class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.new
    @game.player_one = current_user
    @game.player_two = current_user

    # redirect_to
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
    params.require(:game).permit(:player_one_id, :player_two_id, :game_winner)
  end
end
