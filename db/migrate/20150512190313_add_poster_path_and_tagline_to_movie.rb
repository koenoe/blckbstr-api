class AddPosterPathAndTaglineToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :tmdb_poster_path, :string
    add_column :movies, :tagline, :string
  end
end
