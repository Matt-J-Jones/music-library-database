require_relative 'album'
require_relative 'database_connection'

class AlbumRepository
  def all
    albums = []
    sql = 'SELECT id, title, release_year, artist_id FROM albums;'
    result_set = DatabaseConnection.exec_params(sql, [])
    result_set.each do |record|
      album = Album.new
      album.id = record['id'].to_i
      album.title = record['title']
      album.release_year = record['release_year']
      album.artist_id = record['artist_id'].to_i

      albums << album
    end

    return albums
  end

  def all_by_artist(id)
    albums = []
    sql = 'SELECT id, title, release_year, artist_id FROM albums WHERE artist_id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])
    result_set.each do |record|
      album = Album.new
      album.id = record['id'].to_i
      album.title = record['title']
      album.release_year = record['release_year']
      album.artist_id = record['artist_id'].to_i

      albums << album
    end

    return albums
  end

  def find(id)
    sql = 'SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])

    album = Album.new
    album.id = result_set[0]['id'].to_i
    album.title = result_set[0]['title']
    album.release_year = result_set[0]['release_year']
    album.artist_id = result_set[0]['artist_id'].to_i

    return album
  end



  def create(album)
    sql = 'INSERT INTO albums (title, release_year, artist_id) VALUES ($1, $2, $3);'
    result_set = DatabaseConnection.exec_params(sql, [album.title, album.release_year, album.artist_id])

    return album
  end

  def delete(id)
    sql = 'DELETE FROM albums WHERE id = $1;';
    DatabaseConnection.exec_params(sql, [id]);
  end
end

# connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
# DatabaseConnection.connect
# repo = AlbumRepository.new
# result = repo.all_by_artist(1)
# result.each { |item|
#   puts item.title
# }