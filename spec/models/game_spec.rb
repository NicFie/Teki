require "rails_helper"

RSpec.describe Game, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:game_rounds).dependent(:destroy) }
    it { is_expected.to belong_to(:player_one).class_name("User") }
    it { is_expected.to belong_to(:player_two).class_name("User") }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:player_one_id) }
    it { is_expected.to validate_presence_of(:player_two_id) }
  end

  describe "scopes" do
    describe ".existing_game" do
      it "returns games with the given round_count and player_two_id = 1" do
        existing_game = FactoryBot.create(:game, player_two_id: 1, round_count: 3)
        FactoryBot.create(:game, player_two_id: 2, round_count: 3)
        FactoryBot.create(:game, player_two_id: 1, round_count: 5)

        expect(Game.existing_game({ "round_count" => 3, "player_two_id" => 1 })).to eq([existing_game])
      end

      it "doesn't return games with the given round_count and player_two_id = 1" do
        expect(Game.existing_game({ "round_count" => 3, "player_two_id" => 1 })).to be_empty
      end
    end
  end

  describe "#add_rounds_and_challenges" do
    let(:game) { FactoryBot.create(:game, round_count: 3) }
    let!(:challenges) { FactoryBot.create_list(:challenge, 5) }

    it "creates the specified number of game rounds with challenges and sets a winner" do
      game.add_rounds_and_challenges

      expect(game.game_rounds.count).to eq(3)
      expect(game.game_rounds.pluck(:winner_id)).to all(eq(1))
    end
  end

  # TODO finish writing tests
  # describe "#setting_scores" do
  #   let(:game) { FactoryBot.create(:game, player_one: 3, game_winner: 1 ) }
  #   let!(:challenges) { FactoryBot.create_list(:challenge, 5) }
  #
  #   it "creates the specified number of game rounds with challenges and sets a winner" do
  #   end
  # end
end
