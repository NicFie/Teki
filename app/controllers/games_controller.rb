class GamesController < ApplicationController
  # skip_authorization only: [:game_test]

  def waiting_room
    @game = Game.where("player_two_id = 1")
    if @game.exists?
      redirect_to game_path(@game[0].id)
    else
      user = current_user
      redirect_to new_user_game_path(user)
    end
    skip_authorization
  end

  def new
    @game = Game.new
    authorize @game
  end

  def create
    @game = Game.new(game_params)
    authorize @game
    @game.player_one_id = 1
    @game.player_two_id = 1
    @game.save!
    add_rounds_and_challenges(@game.id)
  end

  def add_rounds_and_challenges(id)
    game = Game.find(id)
    rounds = game.round_count
    all_challenges = Challenge.all.to_a

    while rounds.positive?
      challenge = all_challenges[rand(0..all_challenges.size - 1)]
      GameRound.create!(game_id: game.id, challenge_id: challenge.id, winner: User.find(1))
      all_challenges.delete_at(all_challenges.index(challenge))
      rounds -= 1
    end

    redirect_to game_path(game)
  end

  def show
    @game = Game.find(params[:id])
    GameChannel.broadcast_to(
      @game,
      "update page"
    )
    @rounds = @game.game_rounds
    @rounds_left = @rounds.where('winner_id = 1').first
    authorize @game
  end

  def edit
    @game = Game.find(params[:id])
    authorize @game
  end

  def update
    @game = Game.find(params[:id])
    @game.update(game_params)
    @game.save

    respond_to do |format|
      format.js #add this at the beginning to make sure the form is populated.
    end
    authorize @game
  end

  def game_test
    @game = Game.find(params[:id])
    begin
      submission = eval(params[:submission_code])
    rescue SyntaxError => err
      @output = "ERROR: #{err.inspect}"
      @output.gsub!(/(#|<|>)/, "")
      all_passed = []
    # tests variable needs modifying to return not just first test but sequentially after round is won
    else
      tests = eval(@game.game_rounds.where('winner_id = 1').first.challenge.tests)
      @output = []
      count = 0
      all_passed = []

      tests.each do |k, v|
        count += 1
        p "test key: #{k} test value:  #{v}"
        begin
          call = method(submission).call(k)
        rescue StandardError => err
          @output << "ERROR: #{err.message}\n\n"
        rescue ScriptError => err
          @output << "ERROR: #{err.message}\n\n"
        else
          if call == v
            all_passed << true
            @output << "#{count}. Test passed.\nWhen given #{k}, method successfully returned #{v}.\n\n"
          else
            all_passed << false
            @output << "#{count}. Test failed.\n Given: #{k}. Expected: #{v.class == String ? "'#{v}'" : v}. Got: #{
              if call.nil?
                "nil"
              elsif call.class == String
                "'#{call}'"
              elsif call.class == Symbol
                ":#{call}"
              else
                call
              end
            }.\n\n"
          end
        end
      end
      @output = @output.join
    end
    @output.gsub!(/for #<\w+:\w+>\s+\w+\s+\^+/, "")
    p "User #{params[:user_id]} test results:#{all_passed}"
    (all_passed.include?(false) || all_passed.empty?) ? "User #{params[:user_id]} failed." : @winner = "User #{params[:user_id]} wins!"

    # starting the next round code
    @is_a_winner = false
    @is_a_winner = true if (!all_passed.include?(false) && !all_passed.empty?)
    if @is_a_winner == true
      @game_round = @game.game_rounds.where('winner_id = 1').first
      @game_round.winner_id = params[:user_id]
      @game_round.save!
      skip_authorization
    end

    respond_to do |format|
      format.js #add this at the beginning to make sure the form is populated.
      format.json { render json: { results: @output, round_winner: @winner } }
    end

    skip_authorization
  end

  # not sure if this is needed
  def update_display
    respond_to do |format|
      format.js #add this at the beginning to make sure the form is populated.
      format.json { render json: params[:player_one_code].to_json }
    end

    skip_authorization
  end

  def user_code
    @game = Game.find(params[:id])
    respond_to do |format|
      format.js #add this at the beginning to make sure the form is populated.
      format.json { render json: { player_one: @game.player_one_code, player_two: @game.player_two_code } }
    end

    skip_authorization
  end

  private

  def game_params
    params.require(:game).permit(:player_one_id, :player_two_id, :player_one_code, :player_two_code, :round_count, :submission_code)
  end
end
