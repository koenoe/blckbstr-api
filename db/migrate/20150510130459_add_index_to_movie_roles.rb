class AddIndexToMovieRoles < ActiveRecord::Migration
  def change
    add_index :movie_roles, [:movie_id, :person_id, :role_id],
      name: "movie_roles_index",
      unique: true
  end
end
