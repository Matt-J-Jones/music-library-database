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

  get '/' do
    @array_albums = []
    repo = AlbumRepository.new
    artists = ArtistRepository.new
    result = repo.all

    result.each do |item|
      @array_albums << [item.id, item.title, item.release_year, artists.find(item.artist_id).name]
    end

    return erb(:albums)
  end

  get '/albums/:id' do
    album_id = params[:id]
    repo = AlbumRepository.new
    artists = ArtistRepository.new
    result = repo.find(album_id)
    @album = [result.id, result.title, result.release_year, artists.find(result.artist_id).name]

    return erb(:album)
  end

  get '/new_album' do
    return erb(:new_album)
  end

  post '/new_album' do
    repo = ArtistRepository.new
    albums = AlbumRepository.new
    new_album = Album.new

    new_album.title = params[:album_name]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    albums.create(new_album)

    @album_name = params[:album_name]
    @release_year = params[:release_year]
    @artist_name = repo.find(params[:artist_id]).name
    return erb(:album_created)
  end

  get '/new_artist' do
    return erb(:new_artist)
  end

  post '/new_artist' do
    repo = ArtistRepository.new
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]
    repo.create(artist)

    @name = params[:name]
    @genre = params[:genre]
    return erb(:artist_created)
  end

  get '/artists' do
    @artists = []
    repo = ArtistRepository.new
    result = repo.all

    result.each do |item|
      @artists << [item.id, item.name]
    end

    return erb(:artists)
  end

  post '/artists' do
    repo = ArtistRepository.new

    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)
  end
end
