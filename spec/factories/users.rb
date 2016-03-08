FactoryGirl.define do
  factory :spotify_user, class: User do
    uid "darkwingdaphne"
    display_name "darkwingdaphne"
    provider "spotify"
  end
end
