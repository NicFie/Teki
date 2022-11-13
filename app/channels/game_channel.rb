class GameChannel < ApplicationCable::Channel
  def subscribed
    game = Game.find(params[:id])
    stream_for game
  end

  def unsubscribed
    game = Game.find(params[:id])
    if game.player_two_id == 1
      game.destroy
    end
    stop_stream_from game
  end
end
