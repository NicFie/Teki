class Game < ApplicationRecord
  has_many :game_rounds, dependent: :destroy
  belongs_to :player_one, class_name: "User"
  belongs_to :player_two, class_name: "User"

  def add_rounds_and_challenges
    game = Game.find(self.id)
    rounds = game.round_count
    all_challenges = Challenge.all.to_a

    while rounds.positive?
      challenge = all_challenges[rand(0..all_challenges.size - 1)]
      GameRound.create!(game_id: game.id, challenge_id: challenge.id, winner: User.find(1))
      all_challenges.delete_at(all_challenges.index(challenge))
      rounds -= 1
    end

    game.save!
  end

  def self.existing_game(game)
    Game.where("player_two_id = ? and round_count = ?", 1, game["round_count"].to_i)
  end
end
