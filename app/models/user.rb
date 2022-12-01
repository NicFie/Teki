class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :friendships_as_asker, class_name: "Friendship", foreign_key: :asker_id, dependent: :destroy
  has_many :friendships_as_receiver, class_name: "Friendship", foreign_key: :receiver_id, dependent: :destroy
  has_many :games_as_player_one, class_name: "Game", foreign_key: :player_one_id
  has_many :games_as_player_two, class_name: "Game", foreign_key: :player_two_id
  has_many :game_rounds, class_name: "GameRound", foreign_key: :winner_id

  has_many :user_leagues
  has_many :leagues, through: :user_leagues

  has_many :invitations
  has_many :pending_invitations, -> { where confirmed: false }, class_name: 'Invitation', foreign_key: 'friend_id'

  validates :username, length: { maximum: 25 }

  # def friendship_with(user)
  #   Friendship.find_by(asker: self, receiver: user) || Friendship.find_by(asker: user, receiver: self)
  # end

  def friends
    friends_i_sent_invitation = Invitation.where(user_id: id, confirmed: true).pluck(:friend_id)
    friends_i_got_invitation = Invitation.where(friend_id: id, confirmed: true).pluck(:user_id)
    ids = friends_i_sent_invitation + friends_i_got_invitation
    User.where(id: ids)
  end

  def friend_with?(user)
    Invitation.confirmed_record?(id, user.id)
  end

  def send_invitation(user)
    invitations.create(friend_id: user.id)
  end

  def online?
    updated_at > 3.minutes.ago
  end
end
