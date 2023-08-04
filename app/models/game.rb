class Game < ApplicationRecord
  has_many :game_rounds, dependent: :destroy_async
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

  def test_game(submission_code)
    passed = []
    output = []

    begin
      submission = eval(submission_code)
    rescue SyntaxError => e
      p "Syntax Error #{e}"
      output << "<span style=\"color: #ffe66d; font-weight: bold;\">ERROR:</span> #{e.message.gsub!('(eval):3:', '')}"
    # tests variable needs modifying to return not just first test but sequentially after round is won
    else
      game_tests = game_rounds.where('winner_id = 1').first.challenge.tests
      tests = eval(game_tests)
      display_keys = eval(game_tests).keys

      count = 0

      tests.each do |k, v|
        count += 1
        begin
          p "Arriving in call"
          call = method(submission).call(k)
          p "Call is #{call}"
        rescue StandardError => e
          p "Standard Error #{e.message}"
          # binding.pry
          output << "<span style=\"color: #ffe66d; font-weight: bold;\">ERROR:</span> #{e.message.gsub!(/for #| for \d:\w+\W+\w+.+\W+/, '')}<br><br>"
        rescue ScriptError => e
          p "Script Error #{e}"
          # binding.pry
          output << "<span style=\"color: #ffe66d; font-weight: bold;\">ERROR:</span> #{e.message.gsub!(/(for #<\w+:\w+>\s+\w+\s+\^+|for #<\w+:\w+>)/, '')}<br><br>"
        else
          if call == v
            passed << true
            output << "#{count}. <span style=\"color: green; font-weight: bold;\">Test passed:</span><br>When given #{display_keys[count - 1]}, method successfully returned #{v}.<br><br>"
          else
            passed << false
            output << "#{count}. <span style=\"color: #ff6346; font-weight: bold;\">Test failed:</span><br> Given: #{display_keys[count - 1]}. Expected: #{v.class == String ? "'#{v}'" : v}. Got: #{
              if call.nil?
                "nil"
              elsif call.class == String
                "'#{call}'"
              elsif call.class == Symbol
                ":#{call}"
              else
                call
              end
            }.<br><br>"
          end
        end
      end

      { output: output.join, all_passed: passed }
    end
  end

  def setting_scores
    winner = User.find(game_winner)
    loser = User.find(winner.id == player_one.id ? player_two.id : player_one.id)
    rounds_won = game_rounds.where("winner_id =#{winner.id}").to_a.size
    game_won = 3
    rounds_lost = game_rounds.where("winner_id !=#{winner.id}").to_a.size
    bonus = loser.score / 20 >= 0 && loser.score / 20 < 50 ? loser.score / 20 : 50

    winner.score = (winner.score + rounds_won + game_won + bonus) - rounds_lost
    loser.score = (loser.score - bonus - rounds_won)
    self.winner_score = (rounds_won + game_won + bonus) - rounds_lost
    self.loser_score = bonus + rounds_won

    self.loser_score -= loser.score.abs if loser.score.negative?
    loser.score = 0 if loser.score.negative?
    winner.save!
    loser.save!
  end
end
