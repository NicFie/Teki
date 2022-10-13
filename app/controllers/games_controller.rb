class GamesController < ApplicationController
  # skip_authorization only: [:game_test]

  def new
    @game = Game.new
    authorize @game
  end

  def create
    @game = Game.new(game_params)
    authorize @game
    user = current_user
    @game.player_one = user
    @game.player_two = User.find(2)
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
    # lots of dangerous eval, look into ruby taints for possible safer alternative
    @game = Game.find(params[:id])
    submission = eval(params[:player_one_code])
    @output = []
    # tests variable needs modifying to return not just first test but sequentially after round is won
    # below method also needs to consider if the method has 0, 1 or more parameters
    tests = eval(@game.game_rounds.first.challenge.tests)
    tests.each do |k, v|
      call = method(submission).call(k)
      if call == v
        @output << "Test passed.\nWhen given #{k}, method successfully returned #{v}.\n\n"
      else
        @output << "Test failed. Given #{k}, expected #{v}, got #{
          if call.nil?
            "nil"
          elsif call.class == String
            "'#{call}'"
          elsif call.class == Symbol
            ":#{call}"
          else
            call
          end
        }\n"
      end
    end
    @output = @output.join

    respond_to do |format|
      format.js #add this at the beginning to make sure the form is populated.
      format.json { render json: @output.to_json }
    end

    skip_authorization
  end

  private

  def game_params
    params.require(:game).permit(:player_one_id, :player_two_id, :player_one_code, :round_count)
  end
end
