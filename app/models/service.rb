class Service < ActiveRecord::Base
  has_and_belongs_to_many :movies, join_table: 'movie_services', class_name: 'Movie'
end
