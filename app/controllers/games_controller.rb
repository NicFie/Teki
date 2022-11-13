class GamesController < ApplicationController
  # skip_authorization only: [:game_test]
  def new
    @game = Game.new
    authorize @game
  end

  def create
    @check_game = Game.where("player_two_id = ? and round_count = ?", 1, params["game"]["round_count"].to_i)
    if params[:game][:player_one_id] && params[:game][:player_two_id]
      @game = Game.new(game_params)
      authorize @game
      @game.player_one_id = params[:game][:player_one_id]
      @game.player_two_id = params[:game][:player_two_id]
      @game.save!
      add_rounds_and_challenges(@game.id)
    elsif @check_game.exists?
      redirect_to game_path(@check_game[0].id)
      authorize @check_game
    else
      @game = Game.new(game_params)
      @with_friend = @game.with_friend
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

    if @game.player_two_id == 1
      redirect_to game_path(game)
    else
      user = User.find(params[:game][:player_two_id])
      FriendChannel.broadcast_to(user, { notification: "Sending a message to #{user.username}" })
      redirect_to game_path(game)
    end
  end

  def show
    @game = Game.find(params[:id])
    @requests = current_user.pending_invitations
    @rounds = @game.game_rounds
    @rounds_left = @rounds.where('winner_id = 1').first
    redirect_to dashboard_path if @rounds_left.nil?
    if @rounds_left
      @current_game_round_id = @game.game_rounds.where('winner_id = 1').first.id
    end

    GameChannel.broadcast_to(
      @game,
      {
        command: "start game",
        player_one: @game.player_one.id,
        player_two: @game.player_two.id,
        player_two_username: @game.player_two.username,
        player_two_avatar: @game.player_two.avatar
      }
    )

    authorize @game
  end

  def edit
    @game = Game.find(params[:id])
    authorize @game
  end

  def update
    @game = Game.find(params[:id])
    @game.update(game_params)
    @game.save!

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
      @output = "<span style=\"color: #ffe66d; font-weight: bold;\">ERROR:</span> #{err.message.gsub!('(eval):3:', '')}"
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
          @output << "<span style=\"color: #ffe66d; font-weight: bold;\">ERROR:</span> #{err.message.gsub!(/(for #<\w+:\w+>\s+\w+\s+\^+|for #<\w+:\w+>)/, '')}<br><br>"
        rescue ScriptError => err
          @output << "<span style=\"color: #ffe66d; font-weight: bold;\">ERROR:</span> #{err.message.gsub!(/(for #<\w+:\w+>\s+\w+\s+\^+|for #<\w+:\w+>)/, '')}<br><br>"
        else
          if call == v
            all_passed << true
            @output << "#{count}. <span style=\"color: green; font-weight: bold;\">Test passed:</span><br>When given #{display_keys[count - 1]}, method successfully returned #{v}.<br><br>"
          else
            all_passed << false
            @output << "#{count}. <span style=\"color: #ff6346; font-weight: bold;\">Test failed:</span><br> Given: #{display_keys[count - 1]}. Expected: #{v.class == String ? "'#{v}'" : v}. Got: #{
              if call.nil?
                "nil"
              elsif call.class == String
                "'#{call}'"
              elsif call.class == Symbol
                ":#{call}"
              else
                call
              end
            }.<br><br>"
          end
        end
      end
      @output = @output.join
    end
    (all_passed.include?(false) || all_passed.empty?) ? "User #{params[:user_id]} failed." : @winner = "#{User.find(params[:user_id]).username} wins!"
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

      if @game.game_rounds.where('winner_id = 1').to_a.size == 0
        @game_winner = @game.game_rounds.where("winner_id =#{@game.player_one.id}").to_a.size > @game.game_rounds.where("winner_id =#{@game.player_two.id}").to_a.size
        if @game_winner
          @game.game_winner = @game.player_one.id
        else
          @game.game_winner = @game.player_two.id
        end
        @game.save!
        if @game.round_count == 1
          GameChannel.broadcast_to(
            @game,
            {
              command: "update game winner modal",
              round_winner: @winner,
              p1_count: @game.game_rounds.where("winner_id =#{@game.player_one.id}").to_a.size,
              p2_count: @game.game_rounds.where("winner_id =#{@game.player_two.id}").to_a.size,
              game_winner: @game_winner ? @game.player_one.username : @game.player_two.username,
              round_one_instructions: Challenge.find(@game.game_rounds[0].challenge_id).description,
              p1_r1_solution: @game.game_rounds[0].player_one_code,
              p2_r1_solution: @game.game_rounds[0].player_two_code
            }
          )
        elsif @game.round_count == 3
          GameChannel.broadcast_to(
            @game,
            {
              command: "update game winner modal",
              round_winner: @winner,
              p1_count: @game.game_rounds.where("winner_id =#{@game.player_one.id}").to_a.size,
              p2_count: @game.game_rounds.where("winner_id =#{@game.player_two.id}").to_a.size,
              game_winner: @game_winner ? @game.player_one.username : @game.player_two.username,
              round_one_winner: User.find(@game.game_rounds[0].winner_id).username,
              round_one_instructions: Challenge.find(@game.game_rounds[0].challenge_id).description,
              p1_r1_solution: @game.game_rounds[0].player_one_code,
              p2_r1_solution: @game.game_rounds[0].player_two_code,
              round_two_winner: User.find(@game.game_rounds[1].winner_id).username,
              round_two_instructions: Challenge.find(@game.game_rounds[1].challenge_id).description,
              p1_r2_solution: @game.game_rounds[1].player_one_code,
              p2_r2_solution: @game.game_rounds[1].player_two_code,
              round_three_winner: User.find(@game.game_rounds[2].winner_id).username,
              round_three_instructions: Challenge.find(@game.game_rounds[2].challenge_id).description,
              p1_r3_solution: @game.game_rounds[2].player_one_code,
              p2_r3_solution: @game.game_rounds[2].player_two_code
            }
          )
        elsif @game.round_count == 5
          GameChannel.broadcast_to(
            @game,
            {
              command: "update game winner modal",
              round_winner: @winner,
              p1_count: @game.game_rounds.where("winner_id =#{@game.player_one.id}").to_a.size,
              p2_count: @game.game_rounds.where("winner_id =#{@game.player_two.id}").to_a.size,
              game_winner: @game_winner ? @game.player_one.username : @game.player_two.username,
              round_one_winner: User.find(@game.game_rounds[0].winner_id).username,
              round_one_instructions: Challenge.find(@game.game_rounds[0].challenge_id).description,
              p1_r1_solution: @game.game_rounds[0].player_one_code,
              p2_r1_solution: @game.game_rounds[0].player_two_code,
              round_two_winner: User.find(@game.game_rounds[1].winner_id).username,
              round_two_instructions: Challenge.find(@game.game_rounds[1].challenge_id).description,
              p1_r2_solution: @game.game_rounds[1].player_one_code,
              p2_r2_solution: @game.game_rounds[1].player_two_code,
              round_three_winner: User.find(@game.game_rounds[2].winner_id).username,
              round_three_instructions: Challenge.find(@game.game_rounds[2].challenge_id).description,
              p1_r3_solution: @game.game_rounds[2].player_one_code,
              p2_r3_solution: @game.game_rounds[2].player_two_code,
              round_four_winner: User.find(@game.game_rounds[3].winner_id).username,
              round_four_instructions: Challenge.find(@game.game_rounds[3].challenge_id).description,
              p1_r4_solution: @game.game_rounds[3].player_one_code,
              p2_r4_solution: @game.game_rounds[3].player_two_code,
              round_five_winner: User.find(@game.game_rounds[4].winner_id).username,
              round_five_instructions: Challenge.find(@game.game_rounds[4].challenge_id).description,
              p1_r5_solution: @game.game_rounds[4].player_one_code,
              p2_r5_solution: @game.game_rounds[4].player_two_code
            }
          )
        end
        # setting scores.
        winner = User.find(@game.game_winner)
        loser = User.find(winner.id == @game.player_one.id ? @game.player_two.id : @game.player_one.id)
        rounds_won = @game.game_rounds.where("winner_id =#{winner.id}").to_a.size
        game_won = 3
        rounds_lost = @game.game_rounds.where("winner_id !=#{winner.id}").to_a.size
        bonus = loser.score / 20
        if bonus >= 0 && bonus < 50
          winner.score = (winner.score + rounds_won + game_won + bonus) - rounds_lost
          loser.score = (loser.score - bonus - rounds_won)
          @game.winner_score = (rounds_won + game_won + bonus) - rounds_lost
          @game.loser_score = bonus + rounds_won
        else
          winner.score = (winner.score + rounds_won + game_won + 50) - rounds_lost
          loser.score = (loser.score - 50 - rounds_won)
          @game.winner_score = (rounds_won + game_won + 50) - rounds_lost
          @game.loser_score = 50 + rounds_won
        end
        @game.loser_score = @game.loser_score - loser.score.abs if loser.score.negative?
        loser.score = 0 if loser.score.negative?
        winner.save!
        loser.save!
        @game.save!

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

    respond_to do |format|
      format.js #add this at the beginning to make sure the form is populated.
      format.json { render json: { results: @output } }
    end

    skip_authorization
  end

  def user_code
    @game = Game.find(params[:id])
    @current_game_round = @game.game_rounds.where('winner_id = 1').first
    GameChannel.broadcast_to(
      @game,
      {
        command: "update editors",
        player_one: @current_game_round.player_one_code,
        player_two: @current_game_round.player_two_code
      }
    )

    skip_authorization
  end

  def user_ready_next_round
    @game = Game.find(params[:id])
    @round_number = @game.game_rounds.where('winner_id != 1').size + 1
    GameChannel.broadcast_to(
      @game,
      {
        command: "next round",
        player_one_ready: params[:player_one_ready],
        player_two_ready: params[:player_two_ready],
        round_number: @round_number
      }
    )

    skip_authorization
  end


  private

  def game_params
    params.require(:game).permit(:with_friend, :player_one_id, :player_two_id, :round_count, :submission_code, game_rounds: [:player_one_code, :player_two_code])
  end
end
