class Language < ActiveRecord::Base
  has_and_belongs_to_many :movies, join_table: 'movie_languages', class_name: 'Movie'
end
