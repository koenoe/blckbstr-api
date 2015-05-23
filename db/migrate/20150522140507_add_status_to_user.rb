class AddStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :sync_status, :integer
    add_index :users, :sync_status
  end
end
