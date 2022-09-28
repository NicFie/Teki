class AddReferenceToGameRound < ActiveRecord::Migration[7.0]
  def change
    add_reference(:game_rounds, :winner, foreign_key: { to_table: :users })
    add_reference(:games, :game_round, foreign_key: { to_table: :game_rounds })
  end
end
