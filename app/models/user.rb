class User < ActiveRecord::Base
  validates :uid, presence: true

  def self.find_or_create(auth_hash)
    # Find or create a user
    user = self.find_by(uid: auth_hash.id)
    if !user.nil?
      # User found continue on with your life
      return user
    else
      # Create a new user
      user = User.new
      user.uid        = auth_hash.id
      user.provider   = "spotify"
      user.token      = auth_hash.credentials.token
      user.expiration = auth_hash.credentials.expires_at
      if user.save
        return user
      else
        return nil
      end
    end
  end
end
