class UsersController < ApplicationController
  def create
    # env['omniauth.params']
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    user = User.find_or_create(spotify_user)

    if user
      redirect_to status_path(user: spotify_user.id, display: user.display_name.split(" ").first)
    else
      redirect_to status_path(error: "auth_failure")
    end
  end
end
