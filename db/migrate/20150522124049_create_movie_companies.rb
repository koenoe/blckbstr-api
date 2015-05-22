class CreateMovieCompanies < ActiveRecord::Migration
  def change
    create_table :movie_companies, :id => false do |t|
      t.references :company, :movie
    end

    add_index :movie_companies, [:company_id, :movie_id],
      name: "movie_companies_index",
      unique: true
  end
end
