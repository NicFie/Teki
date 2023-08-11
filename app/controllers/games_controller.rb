class GamesController < ApplicationController
  skip_after_action :verify_authorized, only: %i[game_test user_code user_ready_next_round forfeit_round invite_response game_disconnected]
  before_action :find_game, only: %i[show edit update game_test user_code user_ready_next_round forfeit_round game_disconnected]
  after_action :authorize_game, only: %i[new create show edit update]

  def show
    redirect_to dashboard_path unless current_game.current_round

    info = { command: "start game",
             player_one: current_game.player_one.id,
             player_two: current_game.player_two.id,
             player_two_username: current_game.player_two.username,
             player_two_avatar: current_game.player_two.avatar }

    game_broadcast(current_game, info)
  end

  def new
    @game = Game.new
  end

  def edit
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

  def game_test
    result = @game.test_game(params[:submission_code])
    @winner = "#{User.find(params[:user_id]).username} wins!"

    if !result[:all_passed].include?(false) && !result[:all_passed].empty?
      @game_round = @game.game_rounds.where('winner_id = 1').first
      @game_round.winner_id = params[:user_id]
      @game_round.save!
      start_next_round(@game, @winner)
    end

    respond_to do |format|
      format.js #add this at the beginning to make sure the form is populated.
      format.json { render json: { results: result[:output] } }
    end
  end

  def user_code
    @current_game_round = @game.game_rounds.where('winner_id = 1').first
    info = { command: "update editors",
             player_one: @current_game_round.player_one_code,
             player_two: @current_game_round.player_two_code }
    game_broadcast(@game, info)
  end

  def user_ready_next_round
    @round_number = @game.game_rounds.where('winner_id != 1').size + 1
    player_ready = { player_one_ready: params[:player_one_ready],
                     player_two_ready: params[:player_two_ready],
                     round_number: @round_number }
    game_broadcast(@game, player_ready.merge(command: "next round"))

    player_one = User.find(params[:player_one])
    player_two = User.find(params[:player_two])
    friend_broadcast(player_one, player_ready.merge(command: "start game"))
    friend_broadcast(player_two, player_ready.merge(command: "start game"))
  end

  def forfeit_round
    @game_round = @game.current_round
    if @game.player_one == current_user
      @game_round.winner_id = @game.player_two.id
      @winner = "#{User.find(@game.player_two.id).username} wins!"
    else
      @game_round.winner_id = @game.player_one.id
      @winner = "#{User.find(@game.player_one.id).username} wins!"
    end
    @game_round.save!

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
  end

  def cancel_invite
    friend_user = User.find(params['player_two_id'])
    FriendChannel.broadcast_to(friend_user, { command: 'cancel invite' })
  end

  def game_disconnected
    p "Reached game_disconnected"
    @game_rounds = @game.game_rounds
    @game_rounds.each do |game_round|
      game_round.winner_id = params[:other_player]
      game_round.save!
    end
    @winner = "#{User.find(params[:other_player]).username} wins!"
    start_next_round(@game, @winner)
  end

  private

  def game_params
    params.require(:game).permit(:with_friend, :player_one_id, :player_two_id, :round_count, :submission_code, game_rounds: [:player_one_code, :player_two_code])
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
    if game.game_rounds.where('winner_id = 1').to_a.size.zero?
      game_winner = game.game_rounds.where("winner_id =#{game.player_one.id}").to_a.size > game.game_rounds.where("winner_id =#{game.player_two.id}").to_a.size
      if game_winner
        game.game_winner = game.player_one.id
      else
        game.game_winner = game.player_two.id
      end
      game.save!
      broadcast_game_results(game, winner, game_winner)
      game.setting_scores
      game.save!

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

  def friend_broadcast(player, info)
    FriendChannel.broadcast_to(player, info)
  end

  def send_game_invite(game, params)
    user = User.find(params[:player_one_id])
    friend_user = User.find(params[:player_two_id])
    info = { current_game_id: game.id, player_one: user, player_two: friend_user }
    FriendChannel.broadcast_to(user, info.merge(command: 'inviter info'))
    FriendChannel.broadcast_to(friend_user, info.merge(command: 'invited player info'))
  end

  def find_game
    @game = Game.find(params[:id])
  end

  def authorize_game
    authorize @game
  end
end
