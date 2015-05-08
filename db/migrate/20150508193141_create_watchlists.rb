class CreateWatchlists < ActiveRecord::Migration
  def change
    create_table :watchlists, :id => false do |t|
      t.references :movie, :user
    end

    add_index :watchlists, [:movie_id, :user_id],
      name: "watchlists_index",
      unique: true
  end
end
