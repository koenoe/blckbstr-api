class AddPopularityToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :letterboxd_popularity, :integer
    add_column :movies, :tmdb_popularity, :float

    add_index :movies, :letterboxd_popularity
    add_index :movies, :tmdb_popularity
  end
end
