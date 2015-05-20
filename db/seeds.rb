# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Roles
Role.find_or_create_by(title: 'Actor')
Role.find_or_create_by(title: 'Director')
Role.find_or_create_by(title: 'Writer')
Role.find_or_create_by(title: 'Novel')
Role.find_or_create_by(title: 'Screenplay')
Role.find_or_create_by(title: 'Author')