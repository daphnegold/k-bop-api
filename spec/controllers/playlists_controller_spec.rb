require 'rails_helper'

RSpec.describe PlaylistsController, type: :controller do
  let!(:user) { create(:spotify_user) }
  let!(:rspotify_object) { RSpotify::User.new(OmniAuth.config.mock_auth[:spotify]) }
  let(:delete_params) { { uid: "darkwingdaphne", uri: "spotify:track:6W7QMUPT1CT6zSU57DrwNp" } }
  let(:playlist_params) { { uid: "darkwingdaphne" } }
  let(:add_params) { { data: { uid: "darkwingdaphne", uri: "spotify:track:23Uh5wuT3mRhTAs86H5WDt" } } }
  let(:already_in_playlist_params) { { data: { uid: "darkwingdaphne", uri: "spotify:track:6W7QMUPT1CT6zSU57DrwNp" } } }

  describe "#add_song" do
    context "song is not in user's playlist" do
      it "adds song" do
        json_response = { "status": "Ok" }.to_json
        VCR.use_cassette('api_responses', :record => :new_episodes) do
          post :add_song, add_params
          expect(response.body).to eq json_response
        end
      end
    end

    context "invalid params" do
      it "status :bad_request" do
        post :add_song, add_params.tap { |hash| hash[:data].delete(:uid) }
        expect(response.status).to eq 400
      end
    end

    context "song is already in user's playlist" do
      it "doesn't add song" do
        json_response = { "status": "Entry already exists" }.to_json
        VCR.use_cassette('api_responses', :record => :new_episodes) do
          post :add_song, already_in_playlist_params
          expect(response.body).to eq json_response
        end
      end
    end

    context "user doesn't have a playlist" do
      xit "makes a new playlist and adds song" do
        user.playlist = nil
        json_response = { "status": "Ok" }.to_json
        VCR.use_cassette('api_responses', :record => :new_episodes) do
          post :add_song, add_params
          expect(response.body).to eq json_response
        end
      end
    end
  end

  describe "#get_playlist" do
    context "valid uid" do
      it "response status :ok" do
        VCR.use_cassette('api_responses', :record => :new_episodes) do
          post :get_playlist, playlist_params
          expect(response.status).to eq 200
        end
      end
    end

    context "user has no playlist" do
      it "response status :no_content" do
        user.playlist = nil
        VCR.use_cassette('api_responses', :record => :new_episodes) do
          post :get_playlist, playlist_params
          expect(response.status).to eq 204
        end
      end
    end

    context "invalid uid" do
      it "response status :no_content" do
        VCR.use_cassette('api_responses', :record => :new_episodes) do
          post :get_playlist, playlist_params.tap { |hash| hash[:uid] = "darkwingduck" }
          expect(response.status).to eq 204
        end
      end
    end
  end

  describe "#delete_song" do
    context "params contain uri & uid" do
      it "returns a json response" do
        json_response = { "status": "Deleted" }.to_json
        VCR.use_cassette('api_responses', :record => :new_episodes) do
          post :delete_song, delete_params
          expect(response.body).to eq json_response
        end
      end
    end

    context "params have invalid uid " do
      it "returns a json response" do
        json_response = { "error": "Invalid request" }.to_json
        post :delete_song, delete_params.tap { |hash| hash[:uid] = "darkwingduck" }
        expect(response.body).to eq json_response
      end
    end

    context "delete all songs " do
      it "returns a json response" do
        json_response = { "status": "Deleted all" }.to_json
        VCR.use_cassette('api_responses', :record => :new_episodes) do
          post :delete_song, delete_params.tap { |hash| hash[:uri] = "all" }
          expect(response.body).to eq json_response
        end
      end
    end
  end

end
