class Challenge < ApplicationRecord
  has_many :game_rounds

  validates :difficulty, presence: true
end
