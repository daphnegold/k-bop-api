class WelcomeController < ApplicationController
  def letsencrypt
    render plain: ENV['LE_AUTH_RESPONSE']
  end
  
end
