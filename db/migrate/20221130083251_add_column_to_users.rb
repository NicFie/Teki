class AddColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :league
  end
end
