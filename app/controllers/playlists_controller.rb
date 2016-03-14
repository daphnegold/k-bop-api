class PlaylistsController < ApplicationController
  # everything here needs more logic regarding if access to spotify fails for some reason!

  def delete_song
    user_id = params[:uid]
    song_uri = params[:uri]
    user = User.find_by(uid: user_id)

    unless user
      render json: { "error" => "Invalid request" }
    else
      playlist = user.playlist

      if song_uri == "all"
        spotify_playlist = RSpotify::Playlist.find(user.uid, playlist.pid)
        spotify_tracks = spotify_playlist.tracks_cache
        spotify_playlist.remove_tracks!(spotify_tracks)
        PlaylistEntry.where(playlist: playlist).destroy_all

        render json: { "status" => "Deleted all" }, status: :ok

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

        render json: { "status" => "Deleted" }, status: :ok
      end
    end
  end


  def get_playlist
    user_id = params[:uid]
    user = User.find_by(uid: user_id)
    temp = []
    track_count = -1

    if user
      playlist = user.playlist
      spotify_user = User.rspotified(user)
    end

    if playlist
      spotify_playlist = RSpotify::Playlist.find(user.uid, playlist.pid)
      spotify_user.follow(spotify_playlist)
      external_link = spotify_playlist.external_urls["spotify"]

      while true
        tracks = spotify_playlist.tracks(offset: track_count + 1)
        break if tracks.empty?

        tracks.each do |track|
          if playlist.songs.find_by(uri: track.uri)
            temp << format(track)
          end
        end

        track_count += (track_count < 100) ? 101 : 100
      end

      render json: { data: { songs: temp, link: external_link } }, status: :ok
    else
      render json: [], status: :no_content
    end
  end

  def add_song
    user_id = params[:data][:uid]
    song_uri = params[:data][:uri]

    unless user_id && song_uri
      render json: { "error" => "Invalid request" }, status: :bad_request
    else
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
        render json: { "status" => "Entry already exists" }
      else
        song.increment!(:likes)
        spotify_playlist = RSpotify::Playlist.find(user.uid, playlist.pid)
        spotify_user.follow(spotify_playlist)
        spotify_playlist.add_tracks!([song])
        render json: { "status" => "Ok" }, status: :ok
      end
    end
  end
end
