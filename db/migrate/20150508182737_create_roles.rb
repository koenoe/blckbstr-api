class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :title

      t.timestamps null: false
    end
    add_index :roles, :title
  end
end
