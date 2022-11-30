require "test_helper"

class LeagueTest < ActiveSupport::TestCase
  test "should not save article without title" do
    league = League.new
    assert_not league.save, "--Saved the article without a title--"
  end

  test "should save article with title" do
    league = League.new(name: "Le Wagon 990")
    assert league.save, "--Didn't save article with title--"
  end

  test "league name should be less than 20 characters" do
    league = League.new(name: "this is twenty characters long")
    assert_not league.save, "--Saved even over 20 characters--"
  end

  test "a league has many users" do
    league = League.create!(name: "Le Wagon 990")

    user1 = User.new(username: "will", email: "w@d.com", password: "123456")
    user2 = User.new(username: "wlil", email: "d@w.com", password: "123456")

    user1.league_id = league.id
    user2.league_id = league.id

    user1.save!
    user2.save!

    assert league.users.length == 2, "--A league does not have many users--"
  end

  test "a league has many games" do
    league = League.create!(name: "Le Wagon 990")

    user1 = User.create!(username: "will", email: "w@d.com", password: "123456")
    user2 = User.create!(username: "wlil", email: "d@w.com", password: "123456")

    game1 = Game.new
    game2 = Game.new

    game1.player_one = user1
    game1.player_two = user2

    game2.player_one = user1
    game2.player_two = user2

    game1.league_id = league.id
    game2.league_id = league.id

    game1.save!
    game2.save!

    assert league.games.length == 2, "--A league does not have many games--"
  end

  test "should report error" do
    # some_undefined_variable is not defined elsewhere in the test case
    assert_raises(NameError) do
      some_undefined_variable
    end
    # now passes the test as it raises a NameError in the console.
    assert true
  end
end
