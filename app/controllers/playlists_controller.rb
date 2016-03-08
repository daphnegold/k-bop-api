class PlaylistsController < ApplicationController
  # everything here needs more logic regarding if access to spotify fails for some reason!

  def delete_song
    user_id = params[:uid]
    song_uri = params[:uri]

    unless user_id && song_uri
      render json: { "error": "Invalid request" }
    end

    user = User.find_by(uid: user_id)
    playlist = user.playlist
    # do I need this line?
    User.rspotified(user)

    if song_uri == "all"
      spotify_playlist = RSpotify::Playlist.find(user.uid, playlist.pid)
      spotify_tracks = spotify_playlist.tracks_cache
      spotify_playlist.remove_tracks!(spotify_tracks)
      PlaylistEntry.where(playlist: playlist).destroy_all

      render json: { "status": "Deleted all" }, status: :ok

    else
      song = Song.find_by(uri: song_uri)

      if playlist && song
        spotify_track = RSpotify::Track.find(song.uri.split(':').last)
        spotify_playlist = RSpotify::Playlist.find(user.uid, playlist.pid)
        spotify_playlist.remove_tracks!([spotify_track])
        playlist_entry = PlaylistEntry.find_by(playlist: playlist, song: song)

        if playlist_entry
          playlist_entry.destroy
        end
      end

      render json: { "status": "Deleted" }, status: :ok
    end
  end


  def get_playlist
    user_id = params[:uid]
    user = User.find_by(uid: user_id)
    temp = []

    if user
      # do I need this line?
      User.rspotified(user)
      playlist = user.playlist
    end

    if playlist
      spotify_playlist = RSpotify::Playlist.find(user.uid, playlist.pid)

      spotify_playlist.tracks_cache.each do |track|
        likes = get_likes(track.uri)
        comments = get_comments(track.uri)

        temp << {
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

    user = User.find_by(uid: user_id)
    if user
      spotify_user = User.rspotified(user)
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
      song.increment!(:likes)
      spotify_playlist = RSpotify::Playlist.find(user.uid, playlist.pid)
      spotify_playlist.add_tracks!([song])
      render json: { "status": "Ok" }, status: :ok
    end
  end
end
