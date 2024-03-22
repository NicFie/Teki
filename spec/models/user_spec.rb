# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'associations' do
    it { is_expected.to validate_presence_of(:username) }

    it { is_expected.to have_many(:invitations) }
    it { is_expected.to have_many(:pending_invitations) }
    it { is_expected.to have_many(:user_leagues) }
    it { is_expected.to have_many(:leagues).through(:user_leagues) }
    it { is_expected.to have_many(:friendships_as_asker).class_name('Friendship').dependent(:destroy_async) }
    it { is_expected.to have_many(:friendships_as_receiver).class_name('Friendship').dependent(:destroy_async) }
    it { is_expected.to have_many(:games_as_player_one).class_name('Game') }
    it { is_expected.to have_many(:games_as_player_two).class_name('Game') }
    it { is_expected.to have_many(:game_rounds) }
  end

  describe 'User game methods' do
    let(:user_online) { create(:user, online: true) }
    let(:user_with_email) { create(:user, username: 'Will', email: 'will@mail.com') }
    let(:user_less_than_five) { create(:user) }
    let(:user_without_games) { create(:user) }

    before do
      create(:game, player_one: user_online, player_two: user_with_email, game_winner: nil)
      create(:game, player_one: user_online, player_two: user_with_email, game_winner: user_online.id)
      create(:game, player_one: user_with_email, player_two: user_online, game_winner: user_with_email.id)

      10.times do
        create(:game, player_one: user_online, player_two: user_with_email, game_winner: user_online.id)
      end

      3.times do
        create(:game, player_one: user_with_email, player_two: user_less_than_five, game_winner: user_less_than_five.id)
      end
    end

    # after(:context) do
    #   DatabaseCleaner.clean_with(:truncation)
    # end

    describe 'online?' do
      it 'returns true if online' do
        expect(user_online.online?).to be true
      end

      it 'returns false if user offline for more than 3 minutes' do
        expect(user_with_email.online?).to be false
      end
    end

    describe '#completed_games' do
      it 'returns amount of games completed by user' do
        expect(user_online.completed_games.length).to be 12
      end
    end

    describe '#latest_games' do
      it 'returns last 5 games user has played if player has played more than 5 games' do
        expect(user_online.latest_games.length).to be 5
      end

      it 'returns amount of games played if player has played less than 5 games' do
        expect(user_less_than_five.latest_games.length).to be 3
      end
    end

    describe '#games_count' do
      it 'returns amount of games a user has played' do
        expect(user_online.games_count).to be 12
      end

      it "returns 0 if user hasn't played any games" do
        expect(user_without_games.games_count).to be 0
      end

      it 'does not return nil if player has played 0 games' do
        expect(user_without_games.games_count).not_to be_nil
      end
    end
  end

  describe 'User friend methods' do
    let(:friend_user) { create(:user) }
    let(:friend_updated_first) { create(:user) }
    let(:friend_updated_last) { create(:user) }
    let(:non_friend) { create(:user) }

    before do
      create(:invitation, user: friend_user, friend_id: friend_updated_first.id, confirmed: true)
      create(:invitation, user: friend_updated_last, friend_id: friend_user.id, confirmed: true)
      create(:invitation, user: friend_user, friend_id: non_friend.id, confirmed: false)
    end

    describe '#friends' do
      it 'returns only confirmed friends' do
        expect(friend_user.friends).to contain_exactly(friend_updated_first, friend_updated_last)
      end
    end

    describe '#friends_with' do
      it 'returns true if you are friends' do
        expect(friend_user.friend_with?(friend_updated_first)).to be true
      end

      it 'returns false if you are not friends' do
        expect(friend_user.friend_with?(non_friend)).to be false
      end
    end

    describe '#order_friends' do
      before do
        friend_updated_first.update!(updated_at: 1.minute.ago)
        friend_updated_last.update!(updated_at: 2.minutes.ago)
        friend_updated_first.reload
        friend_updated_last.reload
      end

      it 'returns friends ordered by updated_at in descending order' do
        expect(friend_user.order_friends).to eq [friend_updated_first, friend_updated_last]
      end
    end

    describe '#send_invitation' do
      # TODO: test what happens if a user is invited twice
      it 'creates a friend invitation' do
        invitations = friend_user.invitations.count
        friend_user.send_invitation(non_friend)
        expect(friend_user.invitations.count).to be invitations + 1
      end
    end
  end
end
