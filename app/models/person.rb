class Person < ActiveRecord::Base
  has_many :movie_roles, class_name: 'MovieRole'
  has_many :movies, through: :movie_roles
  has_many :roles, through: :movie_roles
end
