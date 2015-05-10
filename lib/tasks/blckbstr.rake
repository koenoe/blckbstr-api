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

        # Get film details
        letterboxd_film = Letterboxd::Scraper.fetch_film(letterboxd_film[:slug])
        tmdb_movie = Tmdb::Movie.detail(letterboxd_film[:tmdb_id])
        tmdb_movie_cast = Tmdb::Movie.casts(tmdb_movie['id'])
        tmdb_movie_crew = Tmdb::Movie.casts(tmdb_movie['id'])

        # Save cast
        tmdb_movie_cast.each do |item|
          person = Person.find_or_create_by
        end

        byebug

        # Check our database
        movie = Movie.find_or_create_by(tmdb_id: tmdb_movie['id'], letterboxd_slug: letterboxd_film[:slug])

        # Put all the unique ids in an array who are updated
        tmdb_ids << tmdb_movie['id']

        # movie = Movie.find_or_create_by(letterboxd_slug: letterboxd_film_details[:slug])
        # movie.title = letterboxd_film_details[:title]
        # movie.letterboxd_popularity = i
        # movie.tmdb_id
        # movie.save!
      end

      # Reset position and popularity of all non popular movies
      Movie.where.not(tmdb_id: tmdb_ids).update_all({ letterboxd_position: nil, tmdb_popularity: nil }) unless slugs.empty?
    end

  end

end