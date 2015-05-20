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
        letterboxd_film = Letterboxd::Scraper.fetch_film(letterboxd_film)

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

def save_movie(letterboxd_film, position = nil)
  # Get tmdb movie details
  tmdb_movie = Tmdb::Movie.detail(letterboxd_film[:tmdb_id])
  # Get omdb movie details
  omdb_movie = Omdb::Api.new.fetch(tmdb_movie['title'])
  omdb_movie = omdb_movie[:movie] unless omdb_movie[:movie].nil?

  # Set genres
  genres = []
  tmdb_movie['genres'].each do |item|
    genre = Genre.find_by(tmdb_id: item['id'])
    genres << genre
  end

  # Save movie
  movie = Movie.find_or_create_by(tmdb_id: tmdb_movie['id'], letterboxd_slug: letterboxd_film[:slug])
  unless tmdb_movie.nil?
    movie.title = tmdb_movie['title']
    movie.letterboxd_position = position unless position.nil?
    movie.genres = genres
    movie.budget = tmdb_movie['budget']
    movie.imdb_id = tmdb_movie['imdb_id']
    movie.tmdb_poster_path = tmdb_movie['poster_path']
    movie.tmdb_backdrop_path = tmdb_movie['backdrop_path']
    movie.tmdb_rating = tmdb_movie['vote_average']
    movie.release_date = Date.parse(tmdb_movie['release_date'])
    movie.runtime = tmdb_movie['runtime']
    movie.plot = tmdb_movie['overview']
    movie.tagline = tmdb_movie['tagline']
    movie.tmdb_popularity = tmdb_movie['popularity']
    movie.trailer_url = letterboxd_film[:trailer]
    # NEED SERVICES HERE (habtm)
  end
  unless omdb_movie.nil?
    movie.certification = omdb_movie.rated
    movie.imdb_rating = omdb_movie.imdb_rating
    movie.metascore = omdb_movie.metascore
    movie.country = omdb_movie.country
    # NEED LANGUAGES HERE (habtm)
  end
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

    role = Role.find_by(title: 'Novel') if item['department'] == 'Writing' && item['job'] == 'Novel'
    role = Role.find_by(title: 'Screenplay') if item['department'] == 'Writing' && item['job'] == 'Screenplay'
    role = Role.find_by(title: 'Author') if item['department'] == 'Writing' && item['job'] == 'Author'
    role = Role.find_by(title: 'Writer') if item['department'] == 'Writing' && item['job'] == 'Writer'
    role = Role.find_by(title: 'Director') if item['department'] == 'Directing' && item['job'] == 'Director'

    next if role.nil?

    person = Person.find_or_create_by(tmdb_id: item['id'])
    person.name = item['name']
    person.tmdb_profile_path = item['profile_path']
    person.save!

    MovieRole.find_or_create_by(person: person, movie: movie, role: role)
  end
end