class WelcomeController < ApplicationController
  def letsencrypt
    render plain: ENV['LE_AUTH_RESPONSE']
  end

  def index
    redirect_to 'https://play.google.com/apps/testing/ninja.k.bop'
  end

end
