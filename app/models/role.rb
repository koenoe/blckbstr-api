class Role < ActiveRecord::Base
  has_many :movie_roles, class_name: 'MovieRole'
  has_many :people, through: :movie_roles
  has_many :movies, through: :movie_roles
end
