class GameRound < ApplicationRecord
  belongs_to :challenge
  belongs_to :game
  belongs_to :winner, class_name: "User"
end
