class CreateAdvices < ActiveRecord::Migration
  def change
    create_table :advices do |t|
      t.references :movie, index: true, foreign_key: true
      t.string :hash
      t.string :email
      t.integer :status

      t.timestamps null: false
    end
    add_index :advices, :hash, unique: true
  end
end
