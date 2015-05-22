class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :title
      t.string :code

      t.timestamps null: false
    end
    add_index :countries, :code, unique: true
  end
end
