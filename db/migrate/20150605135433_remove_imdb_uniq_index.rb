class RemoveImdbUniqIndex < ActiveRecord::Migration
  def up
    remove_index :movies, :imdb_id
    add_index :movies, :imdb_id, unique: false
  end
  def down

  end
end
