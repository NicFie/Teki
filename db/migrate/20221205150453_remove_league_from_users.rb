class RemoveLeagueFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_reference :users, :league
  end
end
