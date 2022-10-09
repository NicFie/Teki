class AddPlayerTwoCodeToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :player_two_code, :string
  end
end
