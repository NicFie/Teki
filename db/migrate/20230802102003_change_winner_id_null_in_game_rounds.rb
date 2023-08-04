class ChangeWinnerIdNullInGameRounds < ActiveRecord::Migration[7.0]
  def change
    change_column_null :game_rounds, :winner_id, true
  end
end
