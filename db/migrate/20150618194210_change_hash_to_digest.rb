class ChangeHashToDigest < ActiveRecord::Migration
  def change
    rename_column :advices, :hash, :digest
  end
end
