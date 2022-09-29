class AddReferenceToGameRounds < ActiveRecord::Migration[7.0]
  def change
    remove_reference :challenges, :game_round, foreign_key: true, index: true
    add_reference :game_rounds, :challenge, null: false, foreign_key: { to_table: :challenges }
  end
end
