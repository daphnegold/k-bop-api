class User < ActiveRecord::Base
  validates :uid, presence: true
  serialize :login_data, Hash
  has_one :playlist

  def self.find_or_create(spotify_user)
    # Find or create a user
    user = self.find_by(uid: spotify_user.id)
    if !user.nil?
      # User found continue on with your life
      user.token      = spotify_user.credentials.token
      user.login_data = spotify_user.to_hash
      user.save
      return user
    else
      # Create a new user
      user = User.new
      user.uid        = spotify_user.id
      user.provider   = "spotify"
      user.token      = spotify_user.credentials.token
      user.login_data = spotify_user.to_hash
      # user.token      = auth_hash.credentials.token
      # user.expiration = auth_hash.credentials.expires_at
      if user.save
        return user
      else
        return nil
      end
    end
  end
end
