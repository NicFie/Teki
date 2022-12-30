class CreateGameTests < ActiveRecord::Migration[7.0]
  def change
    create_table :game_tests do |t|

      t.timestamps
    end
  end
end
