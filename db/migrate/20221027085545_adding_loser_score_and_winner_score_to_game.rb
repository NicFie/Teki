class AddingLoserScoreAndWinnerScoreToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :winner_score, :integer
    add_column :games, :loser_score, :integer
  end
end
