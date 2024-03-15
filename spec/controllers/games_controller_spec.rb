require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  #TODO Continue writing tests for GamesController
  # FactoryBot.create_list(:challenge, 5)
  # let(:player_one) { FactoryBot.create(:user) }
  # let(:player_two) { FactoryBot.create(:user) }
  #
  # describe "#create" do
  #   context "When playing with a friend" do
  #     let(:game_params) do
  #       {
  #         user_id: player_one.id,
  #         game: {
  #           player_one_id: player_one.id,
  #           player_two_id: player_two.id,
  #           round_count: 3,
  #           with_friend: true
  #         }
  #       }
  #     end
  #
  #     it "creates a new game and sends game request to other user" do
  #       sign_in player_one
  #       sign_in player_two
  #
  #       post :create, params: game_params
  #       expect(response).to have_http_status(:success)
  #       game = Game.last
  #       expect(game.player_one_id).to eq(player_one.id)
  #       expect(game.player_two_id).to eq(player_two.id)
  #       expect(game.round_count).to eq(3)
  #     end
  #   end
  #
  #   context "when an existing game is found" do
  #     let(:existing_game) { FactoryBot.create(:game, player_two_id: 1, round_count: 3, game_winner: nil, winner_score: nil, loser_score: nil) }
  #     let(:game_params) do
  #       {
  #         user_id: player_one.id,
  #         game: {
  #           round_count: 3
  #         }
  #       }
  #     end
  #
  #     it "redirects to the existing game path" do
  #       sign_in player_one
  #       sign_in player_two
  #
  #       allow(Game).to receive(:existing_game).and_return([existing_game])
  #       post :create, params: game_params
  #       expect(response).to redirect_to(game_path(existing_game))
  #     end
  #   end
  #
  #   context "when only one player is provided" do
  #     let(:player_one) { FactoryBot.create(:user) }
  #     let(:game_params) do
  #       {
  #         user_id: player_one.id,
  #         game: {
  #           player_one_id: player_one.id,
  #           with_friend: true,
  #           round_count: 5
  #         }
  #       }
  #     end
  #
  #     it "creates a new game with player two as user 1 and redirects to the game path" do
  #       sign_in player_one
  #
  #       post :create, params: game_params
  #       expect(response).to have_http_status(302)
  #       game = Game.last
  #       expect(game).to be_persisted
  #       expect(game.with_friend).to eq(true)
  #       expect(game.player_one_id).to eq(1)
  #       expect(game.player_two_id).to eq(1)
  #       expect(game.round_count).to eq(5)
  #     end
  #   end
  # end
end
