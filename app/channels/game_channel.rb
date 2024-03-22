# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_for "game_#{params[:id]}"
  end

  def unsubscribed
    game = Game.find(params[:id])
    game.destroy if game.player_two_id == 1
    stop_stream_from "game_#{params[:id]}"
  end
end
