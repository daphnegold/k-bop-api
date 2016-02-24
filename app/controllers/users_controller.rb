class UsersController < ApplicationController
  def create
    # auth_hash = request.env['omniauth.auth']
    user = RSpotify::User.new(request.env['omniauth.auth'])

    if user.id.nil?
      render json: "You lose!", status: :ok
    else
      @user = User.find_or_create(user)
      if @user
        render json: "You win!", status: :ok
        # redirect_to 'http://localhost/callback'
      else
        render json: "You lose!", status: :ok
      end
    end
  end
end
