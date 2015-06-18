class Advice < ActiveRecord::Base
  belongs_to :movie
  has_and_belongs_to_many :users, join_table: 'advice_users', class_name: 'User'

  enum status: { default: 0, done: 1}
end
