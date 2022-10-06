class GamesController < ApplicationController
  # skip_authorization only: [:game_test]

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
  #   user_submission = variable "userOneSubmission" recieved
  #   from solution_controller.js via AJAX
  #   our example: descending order challenge is an array of assert equals challenges
  #    challenge_tests = [
  #   [Test.assert_equals(descending_order(42145), 54421)],
  #   [Test.assert_equals(descending_order(145263), 654321)],
  #   [Test.assert_equals(descending_order(123456789), 987654321)]
  # ]
  #    describe("#{challenge.name}") do
  #      it("passes all tests") do
  #      challenge_tests.each do |array|
  #        return array;
  #      end
  #    end
  #   end

    try = eval(params[:round_count])
    @output = method(try).call(10)
    skip_authorization
    respond_to do |format|
      # format.js #add this at the beginning to make sure the form is populated.
      format.json { render json: @output.to_json }
    end
  end

  private

  def game_params
    params.require(:game).permit(:player_one_id, :player_two_id, :round_count)
  end
end
