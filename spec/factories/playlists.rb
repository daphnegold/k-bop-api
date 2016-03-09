FactoryGirl.define do
  factory :playlist, class: Playlist do
    pid "0Q5ohSUKBkHyENC9JcNSki"

    after(:create) do |playlist|
      playlist.songs << create(:song)
    end
  end
end
