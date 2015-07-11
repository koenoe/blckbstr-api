class RemoveStatusFromAdvice < ActiveRecord::Migration
  def change
    remove_column :advices, :status, :integer
  end
end
