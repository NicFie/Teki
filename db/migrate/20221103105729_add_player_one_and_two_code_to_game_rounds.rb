class AddPlayerOneAndTwoCodeToGameRounds < ActiveRecord::Migration[7.0]
  def change
    add_column :game_rounds, :player_one_code, :string
    add_column :game_rounds, :player_two_code, :string
  end
end
