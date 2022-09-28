class Game < ApplicationRecord
  has_many :game_rounds
  has_one :player_one, class_name: "User"
  has_one :player_two, class_name: "User"
end
