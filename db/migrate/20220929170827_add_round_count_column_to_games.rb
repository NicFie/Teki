class AddRoundCountColumnToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :round_count, :integer
  end
end
