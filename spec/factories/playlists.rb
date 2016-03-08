FactoryGirl.define do
  factory :playlist, class: Playlist do
    pid "0Q5ohSUKBkHyENC9JcNSki"

    after(:create) do |playlist|
      playlist.songs << FactoryGirl.create(:song)
    end
  end
end
