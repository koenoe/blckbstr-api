class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :letterboxd_username
      t.string :imdb_username
      t.string :tmdb_username
      t.string :name
      t.string :email

      t.timestamps null: false
    end
    add_index :users, :letterboxd_username, unique: true
    add_index :users, :imdb_username, unique: true
    add_index :users, :tmdb_username, unique: true
    add_index :users, :email, unique: true
  end
end
