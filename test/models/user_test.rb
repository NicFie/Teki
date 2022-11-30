require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save with username to 20 characters" do
    name = User.new(username: "Waiting for opponent......", email: "will@dun.com", password: "123456")
    assert_not name.save, "--Saves user with username above 20 characters--"
  end

  test "should save username below 20 characters" do
    name = User.new(username: "Waiting for opponent...", email: "will@dun.com", password: "123456")
    assert name.save, "--Doesnt save user with username above 20 characters--"
  end
end
