class Movie < ActiveRecord::Base
  has_and_belongs_to_many :genres, join_table: 'movie_genres', class_name: 'Genre'
  has_and_belongs_to_many :views, join_table: 'movie_views', class_name: 'User'

  has_many :movie_roles, class_name: 'MovieRole'
  has_many :roles, through: :movie_roles
  has_many :people, through: :movie_roles
end