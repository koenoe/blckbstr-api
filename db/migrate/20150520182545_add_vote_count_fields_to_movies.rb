class AddVoteCountFieldsToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :tmdb_vote_count, :integer
    add_column :movies, :imdb_vote_count, :integer
    add_column :movies, :letterboxd_vote_count, :integer
  end
end
