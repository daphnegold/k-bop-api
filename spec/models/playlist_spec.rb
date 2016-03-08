require 'rails_helper'

RSpec.describe Playlist, type: :model do
  let(:spotify_playlist) { create(:playlist_with_songs) }

  describe "validations" do
    xit "contains unique songs" do
      spotify_playlist.valid?
      expect(spotify_playlist.errors.full_messages).to include("That song is already in the playlist")
    end
  end
end
