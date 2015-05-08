class CreateMovieViews < ActiveRecord::Migration
  def change
    create_table :movie_views, :id => false do |t|
      t.references :movie, :user
    end

    add_index :movie_views, [:movie_id, :user_id],
      name: "movie_views_index",
      unique: true
  end
end
