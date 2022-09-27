class AddRoundToGame < ActiveRecord::Migration[7.0]
  def change
    add_reference(:games, :round_one, foreign_key: { to_table: :rounds })
    add_reference(:games, :round_two, foreign_key: { to_table: :rounds })
    add_reference(:games, :round_three, foreign_key: { to_table: :rounds })
    add_reference(:games, :round_four, foreign_key: { to_table: :rounds })
    add_reference(:games, :round_five, foreign_key: { to_table: :rounds })
  end
end
