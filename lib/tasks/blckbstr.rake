namespace :blckbstr do

  desc "Fetch genres of TMDb"
  task fetch_genres: :environment do

    Tmdb::Api.key(ENV['tmdb_api_key'])

    result = Tmdb::Genre.list

    ActiveRecord::Base.transaction do
      result['genres'].each do |tmdb_genre|
        genre = Genre.find_or_create_by(tmdb_id: tmdb_genre['id'])
        genre.title = tmdb_genre['name']
        genre.save!
      end
    end

  end

  desc "Fetch popular movies of Letterboxd"
  task fetch_movies: :environment do

    Tmdb::Api.key(ENV['tmdb_api_key'])

    letterboxd_films = Letterboxd::Scraper.fetch_popular(1)

    ActiveRecord::Base.transaction do
      tmdb_ids = []
      letterboxd_films.each_with_index do |letterboxd_film, index|
        i = index + 1

        # Get film details of Letterboxd
        letterboxd_film = Letterboxd::Scraper.fetch_film(letterboxd_film[:slug])

        # Save movie to our database
        save_movie(letterboxd_film[:tmdb_id], letterboxd_film[:slug], i)

        # Put all the unique ids in an array who are updated
        tmdb_ids << letterboxd_film[:tmdb_id]
      end

      # Reset position and popularity of all non popular movies
      Movie.where.not(tmdb_id: tmdb_ids).update_all({ letterboxd_position: nil, tmdb_popularity: nil }) unless tmdb_ids.empty?
    end

  end

end

def save_movie(tmdb_id, letterboxd_slug, position = nil)
  # Get tmdb movie details
  tmdb_movie = Tmdb::Movie.detail(tmdb_id)

  # Set genres
  genres = []
  tmdb_movie['genres'].each do |item|
    genre = Genre.find_by(tmdb_id: item['id'])
    genres << genre
  end

  # Save movie
  movie = Movie.find_or_create_by(tmdb_id: tmdb_movie['id'], letterboxd_slug: letterboxd_slug)
  movie.title = tmdb_movie['title']
  movie.letterboxd_position = position unless position.nil?
  movie.genres = genres
  movie.save!

  # Get cast
  tmdb_movie_cast = Tmdb::Movie.casts(tmdb_movie['id'])
  tmdb_movie_crew = Tmdb::Movie.crew(tmdb_movie['id'])

  # Save cast
  actor_role = Role.find_by(title: 'Actor')
  tmdb_movie_cast.each do |item|
    person = Person.find_or_create_by(tmdb_id: item['id'])
    person.name = item['name']
    person.tmdb_profile_path = item['profile_path']
    person.save!

    MovieRole.find_or_create_by(person: person, movie: movie, role: actor_role)
  end

  # Save crew
  tmdb_movie_crew.each do |item|

    role = Role.find_by(title: 'Writer') if item['department'] == 'Writing' && (item['job'] == 'Author' || item['job'] == 'Screenplay')
    role = Role.find_by(title: 'Director') if item['department'] == 'Directing' && item['job'] == 'Director'

    next if role.nil?

    person = Person.find_or_create_by(tmdb_id: item['id'])
    person.name = item['name']
    person.tmdb_profile_path = item['profile_path']
    person.save!

    MovieRole.find_or_create_by(person: person, movie: movie, role: role)
  end
end