class RemoveFieldsFromMovies < ActiveRecord::Migration
  def change
    remove_column :movies, :language, :string
    remove_column :movies, :country, :string
  end
end
