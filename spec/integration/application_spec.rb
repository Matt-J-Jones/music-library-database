require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'album'

describe Application do
  include Rack::Test::Methods
  let(:app) { Application.new }

  context "POST /" do
    it "creates new album" do
      #
      response = post('/albums', title: "Voyage", release_year: "2022", artist_id: "2")

      expect(response.status).to eq(200)
    end
  end

  context "GET /" do
    it "renders webpage" do
      response = get('/')

      expect(response.status).to eq(200)
      expect(response.body).to include "Doolittle"
      expect(response.body).to include "1989"

      expect(response.body).to include "Voyage"
      expect(response.body).to include "2022"
    end
  end

  context "GET /artists" do
    it "outputs list of artists" do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include "Pixies"
      expect(response.body).to include "ABBA"
      expect(response.body).to include "Taylor Swift"
      expect(response.body).to include "Nina Simone"
      expect(response.body).to include "Kiasmos"
    end
  end

  context "POST /artists" do
    it "creates new artist" do
      response = post('/artists', name: "Wild Nothing", genre: "Indie")
      expect(response.status).to eq(200)
      expect(get('/artists').body).to include '<a href = "/artists/1">Pixies</a>'
      expect(get('/artists').body).to include '<a href = "/artists/7">Wild Nothing</a>'
    end
  end

  context "input forms" do
    it "returns the html form to create new album" do
      response = get('/new_album')

      expect(response.status).to eq (200)
      expect(response.body).to include('<form method="POST" action="/new_album">')
      expect(response.body).to include('<input type="text" name="album_name" />')
      expect(response.body).to include('<input type="text" name="release_year" />')
      expect(response.body).to include('<input type="text" name="artist_id" />')
    end

    it "returns the html form to create new artist" do
      response = get('/new_artist')

      expect(response.status).to eq (200)
      expect(response.body).to include('<form method="POST" action="/new_artist">')
      expect(response.body).to include('<input type="text" name="name" />')
      expect(response.body).to include('<input type="text" name="genre" />')
    end
  end

  context 'POST /new_album' do
    it 'creates new album and returns confirmation page' do
      response = post('/new_album', album_name: 'Reise, Reise', release_year: 2004, artist_id: 7)
      expect(response.status).to eq (200)
      expect(response.body).to include ('<h1>Album Created: Reise, Reise</h1>')
    end

    it 'creates new album from object and returns confirmation' do
      new_album = Album.new
      new_album.title = "Rosenrot"
      new_album.release_year = 2005
      new_album.artist_id = 7

      response = post('/new_album', album_name: new_album.title, release_year: new_album.release_year, artist_id: new_album.artist_id)
      expect(response.status).to eq (200)
      expect(response.body).to include ('<h1>Album Created: Rosenrot</h1>')
    end
  end

  context 'POST /new_artist' do
    it 'creates new artist and returns conformation page' do
      response = post('/new_artist', name: 'Yeah Yeah Yeahs', genre: 'Indie')
      expect(response.status).to eq (200)
      expect(response.body).to include ("Artist Created: Yeah Yeah Yeahs")
    end
  end
end