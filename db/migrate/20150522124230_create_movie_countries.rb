class CreateMovieCountries < ActiveRecord::Migration
  def change
    create_table :movie_countries, :id => false do |t|
      t.references :country, :movie
    end

    add_index :movie_countries, [:country_id, :movie_id],
      name: "movie_countries_index",
      unique: true
  end
end
