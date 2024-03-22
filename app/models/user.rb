# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :friendships_as_asker, class_name: 'Friendship', foreign_key: :asker_id, dependent: :destroy_async, inverse_of: :asker
  has_many :friendships_as_receiver, class_name: 'Friendship', foreign_key: :receiver_id, dependent: :destroy_async, inverse_of: :receiver
  has_many :games_as_player_one, class_name: 'Game', foreign_key: :player_one_id, inverse_of: :player_one
  has_many :games_as_player_two, class_name: 'Game', foreign_key: :player_two_id, inverse_of: :player_two
  has_many :game_rounds, class_name: 'GameRound', foreign_key: :winner_id, inverse_of: :winner

  has_many :user_leagues
  has_many :leagues, through: :user_leagues

  has_many :invitations
  has_many :pending_invitations, -> { where confirmed: false }, class_name: 'Invitation', foreign_key: 'friend_id', inverse_of: :user

  validates :username, presence: true, length: { maximum: 25 }

  scope :leader_board, -> { where.not(id: 1).order(score: :desc).first(10) }

  def completed_games
    games_as_player_one.or(games_as_player_two).where.not(game_winner: nil)
  end

  def latest_games
    completed_games.includes(:player_one, :player_two, :game_rounds).order(updated_at: :desc).limit(5)
  end

  def games_count
    completed_games.count
  end

  def friends
    friends_i_sent_invitation = Invitation.where(user_id: id, confirmed: true).pluck(:friend_id)
    friends_i_got_invitation = Invitation.where(friend_id: id, confirmed: true).pluck(:user_id)
    ids = friends_i_sent_invitation + friends_i_got_invitation
    User.where(id: ids)
  end

  def friend_with?(user)
    Invitation.confirmed_record?(id, user.id)
  end

  def order_friends
    friends.order(updated_at: :desc)
  end

  def send_invitation(user)
    invitations.create(friend_id: user.id)
  end
end
