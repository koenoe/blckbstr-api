class MovieRole < ActiveRecord::Base
  belongs_to :movie
  belongs_to :person
  belongs_to :role
end
