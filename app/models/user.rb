class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :friendships_as_asker, class_name: "Friendship", foreign_key: :asker_id
  has_many :friendships_as_receiver, class_name: "Friendship", foreign_key: :receiver_id
  has_many :games_as_player_one, class_name: "Game", foreign_key: :player_one_id
  has_many :games_as_player_two, class_name: "Game", foreign_key: :player_two_id
  has_many :game_rounds_as_winner, class_name: "GameRound", foreign_key: :winner_id
end
