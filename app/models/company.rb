class Company < ActiveRecord::Base
  has_and_belongs_to_many :movies, join_table: 'movie_companies', class_name: 'Movie'
end
