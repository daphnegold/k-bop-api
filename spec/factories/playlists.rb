FactoryGirl.define do
  factory :song do
    uri "spotify:track:6W7QMUPT1CT6zSU57DrwNp"
    playlist
  end

  factory :playlist do
    pid "0Q5ohSUKBkHyENC9JcNSki"

    factory :playlist_with_songs do
    end
  end
end
