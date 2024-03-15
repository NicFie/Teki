class GamesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[user_code]
  skip_after_action :verify_authorized, only: %i[user_code user_ready_next_round forfeit_round invite_response game_disconnected round_won game_metadata]
  before_action :find_game, only: %i[show update user_ready_next_round forfeit_round game_disconnected round_won game_metadata broadcast_game_results]
  after_action :authorize_game, only: %i[new create show update]

  def show
    @requests = current_user.pending_invitations
    @rounds = @game.game_rounds
    @rounds_left = @rounds.where("winner_id = 1").first
    redirect_to dashboard_path if @rounds_left.nil?

    @game_tests = @game.game_rounds.where("winner_id = 1").first&.challenge&.tests
    @current_game_round_id = @game.game_rounds.where("winner_id = 1").first.id if @rounds_left
    info = { command: "start game",
             player_one: @game.player_one.id,
             player_two: @game.player_two.id,
             player_two_username: @game.player_two.username,
             player_two_avatar: @game.player_two.avatar }

    game_broadcast(info)
  end
  def new
    @game = Game.new
  end

  def create
    if params[:game][:player_one_id] && params[:game][:player_two_id]
      @game = Game.new(game_params.merge(player_one_id: params[:game][:player_one_id], player_two_id: params[:game][:player_two_id]))
      @game.save!
      send_game_invite(@game, params[:game])
    elsif !Game.existing_game(params["game"]).empty?
      @game = Game.existing_game(params["game"])[0]
      redirect_to game_path(@game)
    else
      @game = Game.new(game_params.merge(player_one_id: 1, player_two_id: 1))
      @game.save!
      redirect_to game_path(@game)
    end
  end

  def update
    @game.update(game_params)
    @game.save!

    respond_to(&:js)
  end

  def game_metadata
    data = {
      gameId: @game.id,
      roundCount: @game.round_count,
      userId: current_user.id,
      playerOneId: @game.player_one.id,
      playerTwoId: @game.player_two.id,
      updateUrl: game_path(@game),
      gameRoundMethod: @game.game_rounds.where(winner_id: 1).first&.challenge&.method_template,
      rubyServiceUrl: ENV.fetch("RUBY_TEST_SERVICE"),
      gameTests: @game.game_rounds.where(winner_id: 1).first&.challenge&.tests,
    }

    data[:gameRoundId] = @game.game_rounds.where('winner_id = 1').first&.id if @rounds_left

    respond_to do |format|
      format.json { render json: { meta_data: data } }
    end
  end

  def round_won
    update_game_code(params[:player_one_code], params[:player_two_code])
    @winner = "#{User.find(params[:user_id]).username} wins!"
    @game_round = @game.game_rounds.where("winner_id = 1").first
    @game_round.winner_id = params[:user_id]
    @game_round.save!
    start_next_round(@winner)
  end

  def user_code
    info = { command: "update editors",
             code: params[:code],
             user_id: params[:user_id] }
    game_broadcast(info)
  end

  def user_ready_next_round
    @round_number = @game.game_rounds.where("winner_id != 1").size + 1
    player_ready = { player_one_ready: params[:player_one_ready],
                     player_two_ready: params[:player_two_ready],
                     round_number: @round_number }
    game_broadcast(player_ready.merge(command: "next round"))

    player_one = User.find(params[:player_one])
    player_two = User.find(params[:player_two])
    friend_broadcast(player_one, player_ready.merge(command: "start game"))
    friend_broadcast(player_two, player_ready.merge(command: "start game"))
  end

  def forfeit_round
    update_game_code(params[:player_one_code], params[:player_two_code])
    @game_round = @game.game_rounds.where("winner_id = 1").first
    if @game.player_one == current_user
      @game_round.winner_id = @game.player_two.id
      @winner = "#{User.find(@game.player_two.id).username} wins!"
    else
      @game_round.winner_id = @game.player_one.id
      @winner = "#{User.find(@game.player_one.id).username} wins!"
    end
    @game_round.save!

    start_next_round(@winner)
  end

  def invite_response
    user = User.find(params[:player_one_id])
    friend = User.find(params[:player_two_id])
    if params[:accepted]
      FriendChannel.broadcast_to(user, { command: 'player two accepts', accepted: params[:accepted], game_id: params[:game_id] })
    elsif params[:rejected]
      FriendChannel.broadcast_to(user, { command: 'player two rejects', player_two_username: friend.username })
    end
  end

  def cancel_invite
    friend_user = User.find(params["player_two_id"])
    FriendChannel.broadcast_to(friend_user, { command: "cancel invite" })
  end

  def game_disconnected
    p "Reached game_disconnected"
    @game_rounds = @game.game_rounds
    @game_rounds.each do |game_round|
      game_round.winner_id = params[:other_player]
      game_round.save!
    end
    @winner = "#{User.find(params[:other_player]).username} wins!"
    start_next_round(@winner)
  end

  private

  def update_game_code(player_one_code, player_two_code)
    @game_round = @game.game_rounds.where("winner_id = 1").first
    @game_round.player_one_code = player_one_code
    @game_round.player_two_code = player_two_code
    @game_round.save!
  end

  def game_params
    params.require(:game).permit(:with_friend, :player_one_id, :player_two_id, :round_count, :submission_code, game_rounds: [:player_one_code, :player_two_code])
  end

  def broadcast_game_results(winner, game_winner)
    sorted_game_rounds = @game.game_rounds.order("id ASC")
    nums = ["one", "two", "three", "four", "five"]

    info = { command: "update game winner modal",
             round_winner: winner,
             p1_count: @game.game_rounds.where("winner_id =#{@game.player_one.id}").to_a.size,
             p2_count: @game.game_rounds.where("winner_id =#{@game.player_two.id}").to_a.size,
             game_winner: game_winner ? @game.player_one.username : @game.player_two.username,
             round_count: @game.round_count }

    for i in 1..@game.round_count do
      info["round_#{nums[i - 1]}_winner"] = User.find(@game.game_rounds[i - 1].winner_id).username
      info["round_#{nums[i - 1]}_instructions"] = Challenge.find(sorted_game_rounds[i - 1].challenge_id).description
      info["p1_r#{i}_solution"] = sorted_game_rounds[i - 1].player_one_code
      info["p2_r#{i}_solution"] = sorted_game_rounds[i - 1].player_two_code
    end

    game_broadcast(info)
  end

  def start_next_round(winner)
    if @game.game_rounds.where("winner_id = 1").to_a.size.zero?
      game_winner = @game.game_rounds.where("winner_id =#{@game.player_one.id}").to_a.size > @game.game_rounds.where("winner_id =#{@game.player_two.id}").to_a.size
      if game_winner
        @game.game_winner = @game.player_one.id
      else
        @game.game_winner = @game.player_two.id
      end
      @game.save!
      broadcast_game_results(winner, game_winner)
      @game.setting_scores
      @game.save!
    else
      info = {
        command: "update round winner modal",
        round_winner: winner,
        p1_count: @game.game_rounds.where("winner_id =#{@game.player_one.id}").to_a.size,
        p2_count: @game.game_rounds.where("winner_id =#{@game.player_two.id}").to_a.size,
      }
      game_broadcast(info)
    end
  end

  def game_broadcast(info)
    GameChannel.broadcast_to(game_channel, info)
  end

  def friend_broadcast(player, info)
    FriendChannel.broadcast_to(player, info)
  end

  def send_game_invite(game, params)
    user = User.find(params[:player_one_id])
    friend_user = User.find(params[:player_two_id])
    info = { current_game_id: game.id, player_one: user, player_two: friend_user }
    FriendChannel.broadcast_to(user, info.merge(command: "inviter info"))
    FriendChannel.broadcast_to(friend_user, info.merge(command: "invited player info"))
  end

  def game_channel
    @game_channel = "game_#{params[:id]}"
  end

  def find_game
    @game = Game.find(params[:id])
  end

  def authorize_game
    authorize @game
  end
end
