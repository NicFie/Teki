class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.references :player_one, foreign_key: { to_table: :users }
      t.references :player_two, foreign_key: { to_table: :users }
      t.integer :game_winner
      t.timestamps
    end
  end
end
