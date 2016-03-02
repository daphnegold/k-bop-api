class PlaylistsController < ApplicationController
  # everything here needs more logic regarding if access to spotify fails for some reason!
  
  def get_playlist
    user_id = params[:uid]
    user = User.find_by(uid: user_id)
    playlist = user.playlist
    temp = []

    if playlist
      spotify_playlist = RSpotify::Playlist.find(user.uid, playlist.pid)

      spotify_playlist.tracks_cache.each do |track|
        temp << {
          title: track.name,
          artist: track.artists.first.name,
          uri: track.uri,
          preview: track.preview_url,
          image_large: track.album.images.first["url"],
          spotify_url: track.external_urls["spotify"]
        }
      end

      render json: temp, status: :ok
    else
      render json: [], status: :no_content
    end
  end

  def add_song
    user_id = params[:data][:user]
    song_uri = params[:data][:uri]

    unless user_id && song_uri
      render json: { "error": "Invalid request" }
    end

    # add more logic for if a user is not logged in... that's bad.
    user = User.find_by(uid: user_id)

    if user
      spotify_user = RSpotify::User.new(user.login_data)
      playlist = user.playlist

      unless playlist
        spotify_playlist = spotify_user.create_playlist!('k-bop')
        playlist = Playlist.create(pid: spotify_playlist.id)
        user.playlist = playlist
      end

      song = Song.find_by(uri: song_uri) || Song.create(uri: song_uri)
      playlist_entry = PlaylistEntry.new(song: song, playlist: playlist)
    end

    unless playlist_entry.save
      render json: { "status": "Entry already exists" }
    else
      spotify_playlist = RSpotify::Playlist.find(user.uid, playlist.pid)
      spotify_playlist.add_tracks!([song])
      render json: { "status": "Ok" }, status: :ok
    end
  end
end
