class AddRevenueToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :revenue, :integer
  end
end
