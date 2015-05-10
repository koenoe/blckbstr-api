class Genre < ActiveRecord::Base
  has_and_belongs_to_many :movies, join_table: 'movie_genres', class_name: 'Movie'
end
