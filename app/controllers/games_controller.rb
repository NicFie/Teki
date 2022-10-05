class GamesController < ApplicationController
  def new
    @game = Game.new
    authorize @game
  end

  def create
    @game = Game.new(game_params)
    authorize @game
    user = User.find(1)
    @game.player_one = user
    @game.player_two = user
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
    authorize @game

    GameChannel.broadcast_to(
      @game,
      "HHHEEEELLLOOOO"
    )
  end

  def edit
    @game = Game.find(params[:id])
    authorize @game
  end

  def update
    @game = Game.find(params[:id])
    authorize @game
    @game.update(game_params)
    @game.save

    respond_to do |format|
      format.js #add this at the beginning to make sure the form is populated.
    end
  end

  def game_test
    raise
  end


  private

  def game_params
    params.require(:game).permit(:player_one_id, :player_two_id, :round_count)
  end
end
