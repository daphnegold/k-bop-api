class SongsController < ApplicationController
  def get_songs
    # seed ID will come from the database once there is more to go on
    seed_artist = RSpotify::Artist.find('7aZ221EQfonNG2lO9Hh192')
    artists = seed_artist.related_artists

    recs = []
    temp = []

    artists.shuffle.pop(5).each do |artist|
      tracks = artist.top_tracks(:US)

      recs += tracks
    end

    recs.each do |track|
      likes = Song.get_likes(track.uri)

      temp << {
        title: track.name,
        artist: track.artists.first.name,
        uri: track.uri,
        preview: track.preview_url,
        image_large: track.album.images.first["url"],
        spotify_url: track.external_urls["spotify"],
        likes: likes
      }
    end
    temp = temp.shuffle

    render json: temp, status: :ok
  end
end
