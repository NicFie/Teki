class CreateRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :rounds do |t|
      t.integer :round_winner
      t.datetime :completion_time
      t.references :challenge, null: false, foreign_key: true

      t.timestamps
    end
  end
end
