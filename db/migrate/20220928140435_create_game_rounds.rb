class CreateGameRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :game_rounds do |t|
      t.datetime :completion_time
      t.references :challenge, null: false, foreign_key: true

      t.timestamps
    end
  end
end
