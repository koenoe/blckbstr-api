class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :place_of_birth
      t.date :birthdate
      t.date :deathdate
      t.string :place_of_birth
      t.string :image_url

      t.timestamps null: false
    end
  end
end
