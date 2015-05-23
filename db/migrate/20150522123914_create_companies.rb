class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :tmdb_id
      t.string :title

      t.timestamps null: false
    end
    add_index :companies, :tmdb_id, unique: true
  end
end
