class User < ActiveRecord::Base
  validates :uid, presence: true
  serialize :login_data, Hash
  has_one :playlist

  def self.find_or_create(spotify_user)
    # Find or create a user
    user = self.find_by(uid: spotify_user.id)
    if !user.nil?
      # User found continue on with your life
      user.login_data = spotify_user.to_hash
      user.save
      return user
    else
      # Create a new user
      user = User.new
      user.uid          = spotify_user.id
      user.provider     = "spotify"
      user.display_name = spotify_user.display_name || spotify_user.id 
      user.login_data   = spotify_user.to_hash
      if user.save
        return user
      else
        return nil
      end
    end
  end
end
