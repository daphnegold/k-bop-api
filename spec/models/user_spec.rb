require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:spotify_user) }

  describe "validations" do
    it "is valid" do
      expect(user).to be_valid
    end

    it "requires uid" do
      user.uid = nil
      expect(user).to be_invalid
    end
  end

  describe ".find_or_create" do
    it "creates a valid user" do
      spotify_user = User.find_or_create(OmniAuth.config.mock_auth[:spotify])
      expect(spotify_user).to be_valid
    end

    it "finds a valid user" do
      create(:spotify_user)
      spotify_user = User.find_or_create(OmniAuth.config.mock_auth[:spotify])
      expect(spotify_user).to be_valid
    end
  end
end
