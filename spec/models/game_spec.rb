require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:game_rounds).dependent(:destroy_async) }
    it { is_expected.to belong_to(:player_one).class_name("User") }
    it { is_expected.to belong_to(:player_two).class_name("User") }
  end
end
