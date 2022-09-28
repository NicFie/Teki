class GameRound < ApplicationRecord
  has_one :challenge
  belongs_to :game
  belongs_to :winner, class_name: "User"
end
