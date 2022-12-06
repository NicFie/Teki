class League < ApplicationRecord
  has_many :user_leagues
  has_many :users, through: :user_leagues
  has_many :games

  validates :name, presence: true, length: { maximum: 20 }
end
