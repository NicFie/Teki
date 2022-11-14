class ChangeWithFriendColumnInGames < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:games, :with_friend, nil)
  end
end
