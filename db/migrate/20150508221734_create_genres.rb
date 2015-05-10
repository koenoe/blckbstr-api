class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :title
      t.integer :tmdb_id

      t.timestamps null: false
    end
    add_index :genres, :title
    add_index :genres, :tmdb_id, unique: true
  end
end
