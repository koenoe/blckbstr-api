class CreateMovieLanguages < ActiveRecord::Migration
  def change
    create_table :movie_languages, :id => false do |t|
      t.references :language, :movie
    end

    add_index :movie_languages, [:language_id, :movie_id],
      name: "movie_languages_index",
      unique: true
  end
end
