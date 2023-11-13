class AddOnlineToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :online, :boolean, default: false
  end
end
