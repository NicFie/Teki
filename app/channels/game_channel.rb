class GameChannel < ApplicationCable::Channel
  def subscribed
    game = Game.find(params[:id])
    stream_for game
  end

  def unsubscribed
    game = Game.find(params[:id])
    stop_stream_from game
  end
end
