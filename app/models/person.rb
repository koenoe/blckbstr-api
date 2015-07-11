class Person < ActiveRecord::Base
  has_many :movie_roles, class_name: 'MovieRole'
  has_many :movies, through: :movie_roles
  has_many :roles, through: :movie_roles

  def tmdb_profile_url
    return nil if tmdb_profile_path.blank?
    "http://image.tmdb.org/t/p/original#{tmdb_profile_path}"
  end
end
