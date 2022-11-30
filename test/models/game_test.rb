require "test_helper"

class GameTest < ActiveSupport::TestCase
  test "a game can be saved without a league" do
    user1 = User.create!(username: "will", email: "w@d.com", password: "123456")
    user2 = User.create!(username: "wlil", email: "d@w.com", password: "123456")

    game = Game.new

    game.player_one = user1
    game.player_two = user2

    assert game.save!, "--A game can be saved without a league--"
  end
  # test "the truth" do
  #   assert true
  # end
end
