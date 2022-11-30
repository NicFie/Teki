class AddLeagueToGames < ActiveRecord::Migration[7.0]
  def change
    add_reference :games, :league
  end
end
