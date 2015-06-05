class ChangeCharacterDataType < ActiveRecord::Migration
  def up
    change_column :movie_roles, :character, :text
  end
  def down
    change_column :movie_roles, :character, :string
  end
end
