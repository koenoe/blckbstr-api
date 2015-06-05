class RemoveImdbUniqIndex < ActiveRecord::Migration
  def change
    add_index :movies, :imdb_id, unique: false
  end
end
