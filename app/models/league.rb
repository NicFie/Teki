class League < ApplicationRecord
  has_many :users
  has_many :games

  validates :name, presence: true, length: { maximum: 20 }
end
