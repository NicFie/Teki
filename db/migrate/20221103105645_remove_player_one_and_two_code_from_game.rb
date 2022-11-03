class RemovePlayerOneAndTwoCodeFromGame < ActiveRecord::Migration[7.0]
  def change
    remove_column :games, :player_one_code, :string
    remove_column :games, :player_two_code, :string
  end
end
