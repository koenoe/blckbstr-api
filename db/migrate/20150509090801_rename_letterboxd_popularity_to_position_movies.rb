class RenameLetterboxdPopularityToPositionMovies < ActiveRecord::Migration
  def change
    rename_column :movies, :letterboxd_popularity, :letterboxd_position
  end
end
