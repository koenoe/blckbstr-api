class Country < ActiveRecord::Base
  has_and_belongs_to_many :movies, join_table: 'movie_countries', class_name: 'Movie'
end
