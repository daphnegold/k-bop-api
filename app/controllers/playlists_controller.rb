class PlaylistsController < ApplicationController
  def add_song
    user_id = params[:data][:user]
    song_uri = params[:data][:uri]

    unless user_id && song_uri
      render json: { "error": "Invalid request" }
    end

    user = user.find_by(uid: user_id)

    if user
      playlist = user.playlist
      unless playlist
        playlist = Playlist.create
      end

      song = song.new(uri: song_uri)
    end


    render json: { "status": "ok" }, status: :ok
  end
end
