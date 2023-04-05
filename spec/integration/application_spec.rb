require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "POST /" do
    it "creates new album" do
      #
      response = post('/albums', title: "Voyage", release_year: "2022", artist_id: "2")

      expect(response.status).to eq(200)
    end
  end

  # context "GET /albums/14" do
  #   it "finds created album" do
  #     response = get('/albums/14')

  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq "14, Voyage, 2022, 2"
  #   end
  # end

  context "GET /albums" do
    it "renders webpage" do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include "Doolittle"
      expect(response.body).to include "Released: 1989"

      expect(response.body).to include "Voyage"
      expect(response.body).to include "Released: 2022"
    end
  end

  context "GET /artists" do
    it "outputs list of artists" do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to eq "Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos"
    end
  end

  context "POST /artists" do
    it "creates new artist" do
      response = post('/artists', name: "Wild Nothing", genre: "Indie")
      expect(response.status).to eq(200)
      expect(get('/artists').body).to eq "Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos, Wild Nothing"
    end
  end
end