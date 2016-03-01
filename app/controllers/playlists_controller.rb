class PlaylistsController < ApplicationController
  def add_song
    user_id = params[:data][:user]
    song_uri = params[:data][:uri]

    unless user_id && song_uri
      render json: { "error": "Invalid request" }
    end

    user = User.find_by(uid: user_id)

    if user
      playlist = user.playlist
      unless playlist
        playlist = Playlist.create
        user.playlist = playlist
      end

      song = Song.find_by(uri: song_uri) || Song.create(uri: song_uri)
      playlist_entry = PlaylistEntry.new(song: song, playlist: playlist)
    end

    unless playlist_entry.save
      render json: { "status": "Entry already exists" }
    else
      render json: { "status": "Ok" }, status: :ok
    end
  end
end
