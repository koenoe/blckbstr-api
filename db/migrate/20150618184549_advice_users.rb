class AdviceUsers < ActiveRecord::Migration
  def change
    create_table :advice_users, :id => false do |t|
      t.references :advice, :user
    end

    add_index :advice_users, [:advice_id, :user_id],
      name: "advice_users_index",
      unique: true
  end
end
