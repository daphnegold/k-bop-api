require 'rails_helper'

RSpec.describe UsersController, :vcr, type: :controller do
  let(:user) { create(:spotify_user) }
  let(:rspotify_object) { RSpotify::User.new(OmniAuth.config.mock_auth[:spotify]) }

  describe "#create" do
    before :each do
      authentication_time
    end
    context "auth successful" do
      before { request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:spotify] }

      it "redirects to status_path with successful auth" do
        get :create, provider: :spotify
        expect(response).to redirect_to status_path(user: rspotify_object.id, display: user.display_name.split(" ").first)
      end
    end

    context "auth unsuccessful with no id" do
      before { request.env["omniauth.auth"] = {} }

      it "redirects to status_path with error" do
        get :create, provider: :spotify
        expect(response).to redirect_to status_path(error: "auth_failure")
      end
    end
  end

end
