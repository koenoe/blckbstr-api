class CreateMovieGenres < ActiveRecord::Migration
  def change
    create_table :movie_genres, :id => false do |t|
      t.references :genre, :movie
    end

    add_index :movie_genres, [:genre_id, :movie_id],
      name: "movie_genres_index",
      unique: true
  end
end
