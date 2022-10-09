class AddPlayerOneCodeToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :player_one_code, :string
  end
end
