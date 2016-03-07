class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?

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

  protected

  def json_request?
    request.format.json?
  end
end
