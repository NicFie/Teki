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

  test "should report error" do
    # some_undefined_variable is not defined elsewhere in the test case
    assert_raises(NameError) do
      some_undefined_variable
    end
    # now passes the test as it raises a NameError in the console.
    assert true
  end
end
