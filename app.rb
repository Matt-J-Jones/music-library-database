# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'
connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  post '/albums' do
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo = AlbumRepository.new
    repo.create(new_album)
  end

  get '/albums' do
    @array_albums = []
    repo = AlbumRepository.new
    result = repo.all

    result.each do |item|
      @array_albums << [item.title, item.release_year]
    end

    return erb(:albums)
  end

  get '/artists' do
    artists = []
    repo = ArtistRepository.new
    result = repo.all

    result.each do |item|
      artists << item.name
    end

    return artists.join(", ")
  end

  post '/artists' do
    repo = ArtistRepository.new

    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)
  end
end
