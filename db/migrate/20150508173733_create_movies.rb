class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :tmdb_id
      t.string :imdb_id
      t.string :letterboxd_slug
      t.string :backdrop_url
      t.text :plot
      t.string :trailer_url
      t.date :release_date
      t.integer :runtime
      t.float :letterboxd_rating
      t.float :imdb_rating
      t.float :tmdb_rating
      t.integer :budget
      t.string :language
      t.string :country
      t.string :certification
      t.integer :metascore

      t.timestamps null: false
    end
    add_index :movies, :imdb_id, unique: true
    add_index :movies, :tmdb_id, unique: true
    add_index :movies, :letterboxd_slug, unique: true
    add_index :movies, :release_date
    add_index :movies, :runtime
    add_index :movies, :letterboxd_rating
    add_index :movies, :imdb_rating
    add_index :movies, :tmdb_rating
    add_index :movies, :budget
    add_index :movies, :language
    add_index :movies, :country
    add_index :movies, :certification
    add_index :movies, :metascore
  end
end
