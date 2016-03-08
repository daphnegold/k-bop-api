require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:spotify_user) }
  let(:rspotify_object) { RSpotify::User.new(OmniAuth.config.mock_auth[:spotify]) }

  describe "#create" do
    context "auth successful" do
      before { request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:spotify] }

      it "redirects to status_path with successful auth" do
        VCR.use_cassette('api_responses', :record => :new_episodes) do
          get :create, provider: :spotify
          expect(response).to redirect_to status_path(user: rspotify_object.id, display: user.display_name.split(" ").first)
        end
      end
    end

    context "auth unsuccessful with no id" do
      before { request.env["omniauth.auth"] = {} }

      it "redirects to status_path with error" do
        VCR.use_cassette('api_responses', :record => :new_episodes) do
          get :create, provider: :spotify
          expect(response).to redirect_to status_path(error: "auth_failure")
        end
      end
    end
  end

end
