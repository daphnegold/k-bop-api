FactoryGirl.define do
  factory :spotify_user, class: User do
    uid "darkwingdaphne"
    display_name "darkwingdaphne"
    provider "spotify"
    login_data { RSpotify::User.new(OmniAuth.config.mock_auth[:spotify]).to_hash }
    playlist { create(:playlist) }
  end
end
