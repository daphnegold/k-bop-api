class SongsController < ApplicationController
  def add_comment
    song_uri = params[:data][:uri]
    comment_text = params[:data][:comment]
    uid = params[:data][:uid]

    if song_uri && comment_text && uid
      user = User.find_by(uid: uid)
      song = Song.find_by(uri: song_uri) || Song.create(uri: song_uri)
      song.comments << Comment.create(text: comment_text, user_id: user.id)
      render json: { "status" => "Ok" }, status: :ok
    else
      render json: { "error" => "Comment could not be created" }, status: :bad_request
    end
  end

  def get_songs
    rspotify_auth
    
    user = User.find_by(uid: params[:uid])
    if user && user.playlist
      song = user.playlist.songs.order("Random()").first
    else
      song = Song.order("Random()").first
    end

    if song
      song_uri = song.uri.split(":").last
      seed_track = RSpotify::Track.find(song_uri)
      artists = seed_track.artists.first.related_artists
    else
      seed_artist = RSpotify::Artist.find('0Sadg1vgvaPqGTOjxu0N6c')
      artists = seed_artist.related_artists
    end

    recs = []
    temp = []

    artists.shuffle.pop(5).each do |artist|
      tracks = artist.top_tracks(:US)

      recs += tracks
    end

    recs.each do |track|
      temp << format(track)
    end
    temp = temp.shuffle

    render json: temp, status: :ok
  end
end
