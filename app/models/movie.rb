class Movie < ActiveRecord::Base
  has_and_belongs_to_many :languages, join_table: 'movie_languages', class_name: 'Language'
  has_and_belongs_to_many :countries, join_table: 'movie_countries', class_name: 'Country'
  has_and_belongs_to_many :companies, join_table: 'movie_companies', class_name: 'Company'
  has_and_belongs_to_many :services, join_table: 'movie_services', class_name: 'Service'
  has_and_belongs_to_many :genres, join_table: 'movie_genres', class_name: 'Genre'
  has_and_belongs_to_many :views, join_table: 'movie_views', class_name: 'User'

  has_many :movie_roles, class_name: 'MovieRole'
  has_many :roles, through: :movie_roles
  has_many :people, through: :movie_roles
end