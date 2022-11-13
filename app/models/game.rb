class Game < ApplicationRecord
  has_many :game_rounds, dependent: :destroy
  belongs_to :player_one, class_name: "User"
  belongs_to :player_two, class_name: "User"

  # scope :with_game_winners, -> { where("game_winner != nil") }
end
