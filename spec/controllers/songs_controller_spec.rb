require 'rails_helper'

describe SongsController do

  describe "GET index" do
    it "assigns @songs" do
      artist = FactoryBot.create(:artist)
      get :index
      expect(assigns(:songs).sort { |s1, s2| s1.name <=> s2.name }).to eq(artist.songs.sort { |s1, s2| s1.name <=> s2.name })
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    it "renders the #show view" do
      artist = FactoryBot.create(:artist)
      song = artist.songs.first
      get :show, params: { id: song.id }
      expect(response).to render_template :show
    end
  end

end
