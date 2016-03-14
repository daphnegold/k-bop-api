class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  def rspotify_auth
    RSpotify::authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
  end

  def format(track)
    likes = get_likes(track.uri)
    comments = get_comments(track.uri)

    return {
      title: track.name,
      artist: track.artists.first.name,
      uri: track.uri,
      preview: track.preview_url,
      image_large: track.album.images.first["url"],
      spotify_url: track.external_urls["spotify"],
      likes: likes,
      comments: comments
    }
  end

  def get_comments(track_uri)
    song = Song.find_by(uri: track_uri)

    if song
      return Comment.joins(:user).where(song_id: song.id).pluck_to_hash(:text, :display_name)
    else
      return []
    end
  end

  def get_likes(track_uri)
    song = Song.find_by(uri: track_uri)

    if song
      return song.likes
    else
      return 0
    end
  end
end
