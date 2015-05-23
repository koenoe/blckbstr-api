class CreateMovieServices < ActiveRecord::Migration
  def change
    create_table :movie_services, :id => false do |t|
      t.references :service, :movie
    end

    add_index :movie_services, [:service_id, :movie_id],
      name: "movie_services_index",
      unique: true
  end
end
