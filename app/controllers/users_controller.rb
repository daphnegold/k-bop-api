class UsersController < ApplicationController
  def create
    # env['omniauth.params']
    user = RSpotify::User.new(request.env['omniauth.auth'])

    if user.id.nil?
      redirect_to status_path(error: "auth_failure")
    else
      @user = User.find_or_create(user)
      if @user
        redirect_to status_path(user: user.id)
      else
        redirect_to status_path(error: "auth_failure")
      end
    end
  end
end
