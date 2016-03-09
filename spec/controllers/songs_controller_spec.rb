require 'rails_helper'

RSpec.describe SongsController, type: :controller do
  let!(:user) { create(:spotify_user) }
  let(:song_params) { { uid: "darkwingdaphne" } }
  let(:comment_bad_params) { { data: { } } }
  let(:comment_good_params) do
    { data:
      {
      uri: "spotify:track:6W7QMUPT1CT6zSU57DrwNp",
      comment: "I love K-Pop!",
      uid: "darkwingdaphne"
      }
    }
  end

  describe "#add_comment" do
    context "params contain uri, comment & uid" do
      it "returns a json response" do
        json_response = { "status": "Ok" }.to_json
        post :add_comment, comment_good_params
        expect(response.body).to eq json_response
      end
    end

    context "params do not contain uri, comment & uid" do
      it "returns a json response" do
        json_response = { "error": "Comment could not be created" }.to_json
        post :add_comment, comment_bad_params
        expect(response.body).to eq json_response
      end
    end
  end

  describe "#get_songs" do
    context "user has playlist with songs" do
      xit "response status :ok" do
        VCR.use_cassette('api_responses', :record => :once) do
          get :get_songs, song_params
          expect(response.status).to eq 200
        end
      end
    end

    context "user has playlist without songs" do
      it "response status :ok" do
        user.playlist.songs.destroy_all
        VCR.use_cassette('api_responses', :record => :once) do
          get :get_songs, song_params
          expect(response.status).to eq 200
        end
      end
    end
  end

  context "user has no playlist" do
    it "response status :ok" do
      user.playlist.destroy
      VCR.use_cassette('api_responses', :record => :once) do
        get :get_songs, song_params
        expect(response.status).to eq 200
      end
    end
  end

end
