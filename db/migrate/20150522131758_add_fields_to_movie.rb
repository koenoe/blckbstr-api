class AddFieldsToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :oscars, :integer
    add_column :movies, :wins, :integer
    add_column :movies, :nominations, :integer
  end
end
