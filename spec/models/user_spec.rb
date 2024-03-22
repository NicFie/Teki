# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
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
    before(:context) do
      @user1 = create(:user, online: true)
      @user2 = create(:user, username: 'Will', email: 'will@mail.com')
      @user3 = create(:user)
      @user4 = create(:user)

      create(:game, player_one: @user1, player_two: @user2, game_winner: nil)
      create(:game, player_one: @user1, player_two: @user2, game_winner: @user1.id)
      create(:game, player_one: @user2, player_two: @user1, game_winner: @user2.id)

      10.times do
        create(:game, player_one: @user1, player_two: @user2, game_winner: @user1.id)
      end

      3.times do
        create(:game, player_one: @user2, player_two: @user3, game_winner: @user3.id)
      end
    end

    after(:context) do
      DatabaseCleaner.clean_with(:truncation)
    end

    describe 'online?' do
      it 'returns true if online' do
        expect(@user1.online?).to be true
      end

      it 'returns false if user offline for more than 3 minutes' do
        expect(@user2.online?).to be false
      end
    end

    describe '#completed_games' do
      it 'returns amount of games completed by user' do
        expect(@user1.completed_games.length).to be 12
      end
    end

    describe '#latest_games' do
      it 'returns last 5 games user has played if player has played more than 5 games' do
        expect(@user1.latest_games.length).to be 5
      end

      it 'returns amount of games played if player has played less than 5 games' do
        expect(@user3.latest_games.length).to be 3
      end
    end

    describe '#games_count' do
      it 'returns amount of games a user has played' do
        expect(@user1.games_count).to be 12
        expect(@user3.games_count).to be 3
      end

      it "returns 0 if user hasn't played any games" do
        expect(@user4.games_count).to be 0
        expect(@user4.games_count).not_to be_nil
      end
    end
  end

  describe 'User friend methods' do
    before(:context) do
      @friend_user = create(:user)
      @friend1 = create(:user)
      @friend2 = create(:user)
      @non_friend = create(:user)

      create(:invitation, user: @friend_user, friend_id: @friend1.id, confirmed: true)
      create(:invitation, user: @friend2, friend_id: @friend_user.id, confirmed: true)
      create(:invitation, user: @friend_user, friend_id: @non_friend.id, confirmed: false)
    end

    describe '#friends' do
      it 'returns only confirmed friends' do
        expect(@friend_user.friends).to contain_exactly(@friend1, @friend2)
      end
    end

    describe '#friends_with' do
      it 'returns true if you are friends' do
        expect(@friend_user.friend_with?(@friend1)).to be true
      end

      it 'returns false if you are not friends' do
        expect(@friend_user.friend_with?(@non_friend)).to be false
      end
    end

    describe '#order_friends' do
      before do
        @friend1.update!(updated_at: 1.minute.ago)
        @friend2.update!(updated_at: 2.minutes.ago)
        @friend1.reload
        @friend2.reload
      end

      it 'returns friends ordered by updated_at in descending order' do
        expect(@friend_user.order_friends).to eq [@friend1, @friend2]
      end
    end

    describe '#send_invitation' do
      # TODO: test what happens if a user is invited twice
      it 'creates a friend invitation' do
        invitations = @friend_user.invitations.count
        @friend_user.send_invitation(@non_friend)
        expect(@friend_user.invitations.count).to be invitations + 1
      end
    end
  end
end
