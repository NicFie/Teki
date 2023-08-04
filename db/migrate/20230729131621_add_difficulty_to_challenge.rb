class AddDifficultyToChallenge < ActiveRecord::Migration[7.0]
  def change
    add_column :challenges, :difficulty, :integer, null: false
  end
end
