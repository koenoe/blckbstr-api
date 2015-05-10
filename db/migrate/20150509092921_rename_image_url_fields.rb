class RenameImageUrlFields < ActiveRecord::Migration
  def change
    rename_column :movies, :backdrop_url, :tmdb_backdrop_path
    rename_column :people, :image_url, :tmdb_profile_path
  end
end
