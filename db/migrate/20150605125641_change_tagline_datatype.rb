class ChangeTaglineDatatype < ActiveRecord::Migration
  def up
    change_column :movies, :tagline, :text
  end
  def down
    change_column :movies, :tagline, :string
  end
end
