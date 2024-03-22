# frozen_string_literal: true

class Challenge < ApplicationRecord
  has_many :game_rounds

  validates :difficulty, presence: true
end
