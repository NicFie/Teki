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
    @check_game = Game.where("player_two_id = 1")
    if @check_game.exists?
      redirect_to game_path(@check_game[0].id)
      authorize @check_game
    else
      @game = Game.new(game_params)
      authorize @game
      @game.player_one_id = 1
      @game.player_two_id = 1
      @game.save!
      add_rounds_and_challenges(@game.id)
    end
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
      {command: "update page"}
    )
    @rounds = @game.game_rounds
    @rounds_left = @rounds.where('winner_id = 1').first
    redirect_to dashboard_path if @rounds_left == nil
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
      all_passed = []
    # tests variable needs modifying to return not just first test but sequentially after round is won
    else
      @output = []
      all_passed = []
      game_tests = @game.game_rounds.where('winner_id = 1').first.challenge.tests
      tests = eval(game_tests)
      display_keys = eval(game_tests).keys

      count = 0

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
            @output << "#{count}. Test passed.\nWhen given #{display_keys[count - 1]}, method successfully returned #{v}.\n\n"
          else
            all_passed << false
            @output << "#{count}. Test failed.\n Given: #{display_keys[count - 1]}. Expected: #{v.class == String ? "'#{v}'" : v}. Got: #{
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
    @output.gsub!(/(for #<\w+:\w+>\s+\w+\s+\^+|for #<\w+:\w+>)/, "")
    @output.gsub!(/(#|<|>)/, "")
    p "User #{params[:user_id]} test results:#{all_passed}"
    (all_passed.include?(false) || all_passed.empty?) ? "User #{params[:user_id]} failed." : @winner = "User #{User.find(params[:user_id]).username} wins!"
    @p1_count = 0
    @p2_count = 0
    # starting the next round code
    @is_a_winner = false
    @is_a_winner = true if (!all_passed.include?(false) && !all_passed.empty?)


    if @is_a_winner == true
      @game_round = @game.game_rounds.where('winner_id = 1').first
      @game_round.winner_id = params[:user_id]
      @game_round.save!
      skip_authorization
      p "game rounds where winner id is 1 quantity::::#{@game.game_rounds.where('winner_id = 1').to_a.size}"
      if @game.game_rounds.where('winner_id = 1').to_a.size == 0
        @game_winner = @game.game_rounds.where("winner_id =#{@game.player_one.id}").to_a.size > @game.game_rounds.where("winner_id =#{@game.player_two.id}").to_a.size
        GameChannel.broadcast_to(
          @game,
          {
            command: "update game winner modal",
            round_winner: @winner,
            p1_count: @game.game_rounds.where("winner_id =#{@game.player_one.id}").to_a.size,
            p2_count: @game.game_rounds.where("winner_id =#{@game.player_two.id}").to_a.size,
            game_winner: @game_winner ? @game.player_one.username : @game.player_two.username
          }
        )
      else
        GameChannel.broadcast_to(
          @game,
          {
            command: "update round winner modal",
            round_winner: @winner,
            p1_count: @game.game_rounds.where("winner_id =#{@game.player_one.id}").to_a.size,
            p2_count: @game.game_rounds.where("winner_id =#{@game.player_two.id}").to_a.size
          }
        )
      end
    end

    @access_this = @game.game_rounds.where('winner_id = 12')


    respond_to do |format|
      format.js #add this at the beginning to make sure the form is populated.
      format.json { render json: { results: @output } }
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
