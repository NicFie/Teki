require 'rails_helper'

RSpec.describe User, type: :model do
  it 'returns name of user' do
    user = create(:user)
    expect(user.username).to eq "Billy"
  end
end
