class SongsController < ApplicationController
  def get_songs
    # seed ID will come from the database once there is more to go on
    seed_artist = RSpotify::Artist.find('7aZ221EQfonNG2lO9Hh192')
    artists = seed_artist.related_artists

    recs = []
    temp = []

    artists.each do |artist|
      tracks = artist.top_tracks(:US)

      recs += tracks
    end

    recs.shuffle.pop(20).each do |track|
      temp << {
        title: track.name,
        artist: track.album.artists.first.name,
        preview: track.preview_url,
        image: track.album.images.first["url"],
        spotify_url: track.external_urls
      }
    end


    render json: temp, status: :ok
  end
end
