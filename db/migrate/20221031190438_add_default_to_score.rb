class AddDefaultToScore < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :score, :integer, default: 0
  end
end
