class GamesController < ApplicationController
  skip_after_action :verify_authorized, only: %i[game_test user_code user_ready_next_round forfeit_round invite_response game_disconnected]

  def new
    @game = Game.new
    authorize @game
  end

  def create
    if params[:game][:player_one_id] && params[:game][:player_two_id]
      @game = Game.new(game_params.merge(player_one_id: params[:game][:player_one_id], player_two_id: params[:game][:player_two_id]))
      @game.save!
      send_game_invite(@game, params[:game])
    elsif Game.existing_game(params["game"]).exists?
      @game = Game.existing_game(params["game"])[0]
      redirect_to game_path(@game)
    else
      @game = Game.new(game_params.merge(player_one_id: 1, player_two_id: 1))
      @game.save!
      redirect_to game_path(@game)
    end
    @game.add_rounds_and_challenges if @game.game_rounds.empty?
    authorize @game
  end

  def show
    @game = Game.find(params[:id])
    @requests = current_user.pending_invitations
    @rounds = @game.game_rounds
    @rounds_left = @rounds.where('winner_id = 1').first
    redirect_to dashboard_path if @rounds_left.nil?
    @current_game_round_id = @game.game_rounds.where('winner_id = 1').first.id if @rounds_left
    info = { command: "start game",
             player_one: @game.player_one.id,
             player_two: @game.player_two.id,
             player_two_username: @game.player_two.username,
             player_two_avatar: @game.player_two.avatar}

    game_broadcast(@game, info)
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
    # starting the next round code
    @is_a_winner = false
    @is_a_winner = true if (!all_passed.include?(false) && !all_passed.empty?)

    if @is_a_winner == true
      @game_round = @game.game_rounds.where('winner_id = 1').first
      @game_round.winner_id = params[:user_id]
      @game_round.save!
      skip_authorization
      start_next_round(@game, @winner)
    end

    respond_to do |format|
      format.js #add this at the beginning to make sure the form is populated.
      format.json { render json: { results: @output } }
    end

    # skip_authorization
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

    # skip_authorization
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
    # reusing this function for game with friend
    player_one = User.find(params[:player_one])
    player_two = User.find(params[:player_two])
    FriendChannel.broadcast_to(
      player_one,
      {
        command: "start game",
        player_one_ready: params[:player_one_ready],
        player_two_ready: params[:player_two_ready],
        round_number: @round_number
      }
    )
    FriendChannel.broadcast_to(
      player_two,
      {
        command: "start game",
        player_one_ready: params[:player_one_ready],
        player_two_ready: params[:player_two_ready],
        round_number: @round_number
      }
    )
    # skip_authorization
  end

  def forfeit_round
    @game = Game.find(params[:id])
    @game_round = @game.game_rounds.where('winner_id = 1').first
    if @game.player_one == current_user
      @game_round.winner_id = @game.player_two.id
      @winner = "#{User.find(@game.player_two.id).username} wins!"
    else
      @game_round.winner_id = @game.player_one.id
      @winner = "#{User.find(@game.player_one.id).username} wins!"
    end
    @game_round.save!
    # skip_authorization
    start_next_round(@game, @winner)
  end

  def invite_response
    user = User.find(params[:player_one_id])
    friend = User.find(params[:player_two_id])
    if params[:accepted]
      FriendChannel.broadcast_to(user, { command: 'player two accepts', accepted: params[:accepted], game_id: params[:game_id] })
    elsif params[:rejected]
      FriendChannel.broadcast_to(user, { command: 'player two rejects', player_two_username: friend.username })
    end
    # skip_authorization
  end

  def cancel_invite
    friend_user = User.find(params['player_two_id'])
    FriendChannel.broadcast_to(friend_user, { command: 'cancel invite' })
  end

  def game_disconnected
    @game = Game.find(params[:id])
    p "Reached game_disconnected"
    @game_rounds = @game.game_rounds
    @game_rounds.each do |game_round|
      game_round.winner_id = params[:other_player]
      game_round.save!
    end
    @winner = "#{User.find(params[:other_player]).username} wins!"
    start_next_round(@game, @winner)
    # skip_authorization
  end

  private

  def game_params
    params.require(:game).permit(:with_friend, :player_one_id, :player_two_id, :round_count, :submission_code, game_rounds: [:player_one_code, :player_two_code])
  end

  def setting_scores(game)
    winner = User.find(game.game_winner)
    loser = User.find(winner.id == game.player_one.id ? game.player_two.id : game.player_one.id)
    rounds_won = game.game_rounds.where("winner_id =#{winner.id}").to_a.size
    game_won = 3
    rounds_lost = game.game_rounds.where("winner_id !=#{winner.id}").to_a.size
    bonus = loser.score / 20
    if bonus >= 0 && bonus < 50
      winner.score = (winner.score + rounds_won + game_won + bonus) - rounds_lost
      loser.score = (loser.score - bonus - rounds_won)
      game.winner_score = (rounds_won + game_won + bonus) - rounds_lost
      game.loser_score = bonus + rounds_won
    else
      winner.score = (winner.score + rounds_won + game_won + 50) - rounds_lost
      loser.score = (loser.score - 50 - rounds_won)
      game.winner_score = (rounds_won + game_won + 50) - rounds_lost
      game.loser_score = 50 + rounds_won
    end
    game.loser_score = game.loser_score - loser.score.abs if loser.score.negative?
    loser.score = 0 if loser.score.negative?
    winner.save!
    loser.save!
    game.save!
  end

  def broadcast_game_results(game, winner, game_winner)
    sorted_game_rounds = game.game_rounds.order('id ASC')
    nums = ["one", "two", "three", "four", "five"]

    info = { command: "update game winner modal",
             round_winner: winner,
             p1_count: game.game_rounds.where("winner_id =#{game.player_one.id}").to_a.size,
             p2_count: game.game_rounds.where("winner_id =#{game.player_two.id}").to_a.size,
             game_winner: game_winner ? game.player_one.username : game.player_two.username }

    for i in 1..game.round_count do
      info["round_#{nums[i - 1]}_winner"] = User.find(game.game_rounds[i - 1].winner_id).username
      info["round_#{nums[i - 1]}_instructions"] = Challenge.find(sorted_game_rounds[i - 1].challenge_id).description
      info["p1_r#{i}_solution"] = sorted_game_rounds[i - 1].player_one_code
      info["p2_r#{i}_solution"] = sorted_game_rounds[i - 1].player_two_code
    end

    game_broadcast(game, info)
  end

  def start_next_round(game, winner)
    if game.game_rounds.where('winner_id = 1').to_a.size == 0
      game_winner = game.game_rounds.where("winner_id =#{game.player_one.id}").to_a.size > game.game_rounds.where("winner_id =#{game.player_two.id}").to_a.size
      if game_winner
        game.game_winner = game.player_one.id
      else
        game.game_winner = game.player_two.id
      end
      game.save!
      broadcast_game_results(game, winner, game_winner)
      setting_scores(game)

    else
      GameChannel.broadcast_to(
        game,
        {
          command: "update round winner modal",
          round_winner: winner,
          p1_count: game.game_rounds.where("winner_id =#{game.player_one.id}").to_a.size,
          p2_count: game.game_rounds.where("winner_id =#{game.player_two.id}").to_a.size
        }
      )
    end
  end

  def game_broadcast(game, info)
    GameChannel.broadcast_to(game, info)
  end

  def send_game_invite(game, params)
    user = User.find(params[:player_one_id])
    friend_user = User.find(params[:player_two_id])
    info = { current_game_id: game.id, player_one: user, player_two: friend_user }
    FriendChannel.broadcast_to(user, info.merge(command: 'inviter info'))
    FriendChannel.broadcast_to(friend_user, info.merge(command: 'invited player info'))
    # skip_authorization
  end
end
