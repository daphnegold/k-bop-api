class PlaylistsController < ApplicationController
  def add_song
    user_id = params[:data][:user]
    song_uri = params[:data][:uri]

    user = user.find_by(uid: user_id)

    if user
      playlist = user.playlist
      song = song.new(uri: song_uri)
    end


    render json: { "status": "ok" }, status: :ok
  end
end
