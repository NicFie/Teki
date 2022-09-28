class AddReferenceToGameRound < ActiveRecord::Migration[7.0]
  def change
    add_reference :game_rounds, :winner, null: false, foreign_key: { to_table: :users }
  end
end
