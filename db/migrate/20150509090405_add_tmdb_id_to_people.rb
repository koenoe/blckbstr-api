class AddTmdbIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :tmdb_id, :integer
    add_index :people, :tmdb_id, unique: true
  end
end
