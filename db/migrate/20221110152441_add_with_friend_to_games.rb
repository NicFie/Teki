class AddWithFriendToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :with_friend, :boolean, default: :false
  end
end
