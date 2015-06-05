class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :user, index: true, foreign_key: true
      t.references :movie, index: true, foreign_key: true
      t.float :letterboxd_rating
      t.float :imdb_rating

      t.timestamps null: false
    end
  end
end
