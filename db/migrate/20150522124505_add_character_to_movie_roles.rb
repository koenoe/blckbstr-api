class AddCharacterToMovieRoles < ActiveRecord::Migration
  def change
    add_column :movie_roles, :character, :string
  end
end
