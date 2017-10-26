require 'rails_helper'

describe SongsController do
  
  describe "GET index" do
    it "assigns @songs" do
      song = FactoryBot.create(:song)
      get :index
      expect(assigns(:songs)).to eq([song])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    it "renders the #show view" do
      song = FactoryBot.create(:song)
      get :index, { id: song.id }
      response.should render_template :show
    end
  end

end
