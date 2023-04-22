require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to validate_presence_of(:username) }

    it { is_expected.to have_many(:invitations) }
    it { is_expected.to have_many(:pending_invitations) }
    it { is_expected.to have_many(:user_leagues) }
    it { is_expected.to have_many(:leagues).through(:user_leagues) }
    it { is_expected.to have_many(:friendships_as_asker).class_name("Friendship").dependent(:destroy_async) }
    it { is_expected.to have_many(:friendships_as_receiver).class_name("Friendship").dependent(:destroy_async) }
    it { is_expected.to have_many(:games_as_player_one).class_name("Game") }
    it { is_expected.to have_many(:games_as_player_two).class_name("Game") }
    it { is_expected.to have_many(:game_rounds) }
  end

  describe 'online?' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user, username: "Will", email: "will@mail.com", updated_at: 5.minutes.ago) }

    it 'returns true if online' do
      expect(user1.online?).to eq true
    end

    it 'returns false if user offline for more than 3 minutes' do
      expect(user2.online?).to eq false
    end
  end
end
