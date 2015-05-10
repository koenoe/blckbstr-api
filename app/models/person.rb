class Person < ActiveRecord::Base
  has_many :movie_roles, class_name: 'MovieRole'
  has_many :movies, through: :movie_roles
  has_many :roles, through: :movie_roles

  def add_role(role, movie)
    role = Role.find_by(name: role) unless role.is_a?(Role)
    MovieRole.create(people: self, movie: movie, role: role)
  end
end
