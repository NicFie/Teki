class GameRound < ApplicationRecord
  has_one :challenge
  # belongs_to :game
  has_one :winner, class_name: "User"
end
