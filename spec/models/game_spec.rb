# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game do
  describe 'associations' do
    it { is_expected.to have_many(:game_rounds).dependent(:destroy) }
    it { is_expected.to belong_to(:player_one).class_name('User') }
    it { is_expected.to belong_to(:player_two).class_name('User') }
  end

  describe 'scopes' do
    describe '.existing_game' do
      let(:player_one) { create(:user) }
      let(:player_two) { create(:user) }

      it 'returns games with the given round_count and player_two_id = 1' do
        existing_game = create(:game, player_two_id: 1, round_count: 3)
        create(:game, player_two_id: player_two.id, round_count: 3)
        create(:game, player_two_id: player_one.id, round_count: 5)

        expect(described_class.existing_game({ 'round_count' => 3, 'player_two_id' => 1 })).to eq([existing_game])
      end

      it "doesn't return games with the given round_count and player_two_id = 1" do
        expect(described_class.existing_game({ 'round_count' => 3, 'player_two_id' => 1 })).to be_empty
      end
    end
  end

  describe '#add_rounds_and_challenges' do
    let(:game) { create(:game, round_count: 3) }

    before do
      create_list(:challenge, 5)
      game.add_rounds_and_challenges
    end

    it 'creates the specified number of game rounds' do
      expect(game.game_rounds.count).to eq(3)
    end

    it 'sets an automatic winner for each round' do
      expect(game.game_rounds.pluck(:winner_id)).to all(eq(1))
    end
  end

  # TODO: finish writing tests
  # describe "#setting_scores" do
  #   let(:game) { create(:game, player_one: 3, game_winner: 1 ) }
  #   let!(:challenges) { create_list(:challenge, 5) }
  #
  #   it "creates the specified number of game rounds with challenges and sets a winner" do
  #   end
  # end
end
