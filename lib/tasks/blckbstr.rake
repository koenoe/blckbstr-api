namespace :blckbstr do

  desc "Sync genres of TMDb"
  task sync_genres: :environment do

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

  desc "Sync users"
  task sync_users: :environment do
    Tmdb::Api.key(ENV['tmdb_api_key'])

    # ActiveRecord::Base.transaction do

      User.needs_to_sync.each do |user|

        # First update sync status
        user.sync_status = User.sync_statuses[:syncing]
        user.save!

        # Fetch watchlist
        watchlist = Letterboxd::Scraper.fetch_watchlist(user.letterboxd_username)
        watchlist.each do |letterboxd_film|
          movie = Movie.find_by(letterboxd_slug: letterboxd_film[:slug])
          if movie.nil?
            # Get film details of Letterboxd
            letterboxd_film = Letterboxd::Scraper.fetch_film(letterboxd_film[:slug])

            # Save movie to our database
            movie = save_movie(letterboxd_film)
          end

          user.watchlist << movie unless user.watchlist.exists?(id: movie.id)
        end

        # Fetch seen
        seen = Letterboxd::Scraper.fetch_seen(user.letterboxd_username)
        seen.each do |letterboxd_film|
          movie = Movie.find_by(letterboxd_slug: letterboxd_film[:slug])
          if movie.nil?
            # Get film details of Letterboxd
            letterboxd_film = Letterboxd::Scraper.fetch_film(letterboxd_film[:slug])

            # Save movie to our database
            movie = save_movie(letterboxd_film)
          end

          user.movies_seen << movie unless user.movies_seen.exists?(id: movie.id)
        end

        # Fetch rated 5
        rated_5 = Letterboxd::Scraper.fetch_rated(user.letterboxd_username, 5)
        rated_5.each do |letterboxd_film|
          movie = Movie.find_by(letterboxd_slug: letterboxd_film[:slug])
          if movie.nil?
            # Get film details of Letterboxd
            letterboxd_film = Letterboxd::Scraper.fetch_film(letterboxd_film[:slug])

            # Save movie to our database
            movie = save_movie(letterboxd_film)

            # Save rating
            rating = Rating.find_or_create_by(movie: movie, user: user)
            rating.letterboxd_rating = 10
            rating.save!
          end
        end

        # Fetch liked
        liked = Letterboxd::Scraper.fetch_liked(user.letterboxd_username)
        liked.each do |letterboxd_film|
          movie = Movie.find_by(letterboxd_slug: letterboxd_film[:slug])
          if movie.nil?
            # Get film details of Letterboxd
            letterboxd_film = Letterboxd::Scraper.fetch_film(letterboxd_film[:slug])

            # Save movie to our database
            movie = save_movie(letterboxd_film)

            # Save like
            like = Like.find_or_create_by(likeable: movie, user:user)
          end
        end


        # Fetch followers and following
        followers = Letterboxd::Scraper.fetch_followers(user.letterboxd_username)
        following = Letterboxd::Scraper.fetch_following(user.letterboxd_username)

        followers.each do |letterboxd_user|
          follower = User.find_or_create_by(letterboxd_username: letterboxd_user[:username])
          follower.name = letterboxd_user[:name]
          follower.sync_status = User.sync_statuses[:default] if follower.sync_status.nil?
          follower.follow(user) unless follower.following?(user)
          follower.save!
        end

        following.each do |letterboxd_user|
          following = User.find_or_create_by(letterboxd_username: letterboxd_user[:username])
          following.name = letterboxd_user[:name]
          following.sync_status = User.sync_statuses[:default] if following.sync_status.nil?
          following.save!

          user.follow(following) unless user.following?(following)
        end

        user.sync_status = User.sync_statuses[:synced]
        user.save!
      end

    # end
  end

  desc "Sync popular movies of Letterboxd"
  task sync_movies: :environment do
    Tmdb::Api.key(ENV['tmdb_api_key'])

    letterboxd_films = Letterboxd::Scraper.fetch_popular(1)

    # ActiveRecord::Base.transaction do
      tmdb_ids = []
      letterboxd_films.each_with_index do |letterboxd_film, index|
        i = index + 1

        # Get film details of Letterboxd
        letterboxd_film = Letterboxd::Scraper.fetch_film(letterboxd_film[:slug])

        next if letterboxd_film.nil?

        # Save movie to our database
        save_movie(letterboxd_film, i)

        # Put all the unique ids in an array who are updated
        tmdb_ids << letterboxd_film[:tmdb_id]
      end

      # Reset position and popularity of all non popular movies
      Movie.where.not(tmdb_id: tmdb_ids).update_all({ letterboxd_position: nil, tmdb_popularity: nil }) unless tmdb_ids.empty?
    # end

  end

end

def save_movie(letterboxd_film, position = nil)
  # Get tmdb movie details
  tmdb_movie = Tmdb::Movie.detail(letterboxd_film[:tmdb_id])

  return if tmdb_movie.nil?

  # Get omdb movie details
  begin
    omdb_movie = Omdb::Api.new.fetch(tmdb_movie['title'], letterboxd_film[:release_year])
    if omdb_movie[:status].present?
      if omdb_movie[:status].to_s == '200'
        omdb_movie = omdb_movie[:movie] if omdb_movie[:movie].present?
      else
        omdb_movie = nil
      end
    end
  rescue Exception => e
    puts "Error fetching omdb movie: #{e.message}"
  end

  # Set genres
  genres = []
  tmdb_movie['genres'].each do |item|
    genre = Genre.find_by(tmdb_id: item['id'])
    genres << genre
  end

  # Set languages
  languages = []
  tmdb_movie['spoken_languages'].each do |item|
    language = Language.find_or_create_by(code: item['iso_639_1'])
    language.title = item['name']
    language.save!

    languages << language
  end

  # Set countries
  countries = []
  tmdb_movie['production_countries'].each do |item|
    country = Country.find_or_create_by(code: item['iso_3166_1'])
    country.title = item['name']
    country.save!

    countries << country
  end

  # Set companies
  companies = []
  tmdb_movie['production_companies'].each do |item|
    company = Company.find_or_create_by(tmdb_id: item['id'])
    company.title = item['name']
    company.save!

    companies << company
  end

  # Set services
  services = []
  letterboxd_film[:availability].each do |key, value|
    service = Service.find_by(slug: key.to_s) if value == true
    services << service unless service.nil?
  end

  # Save movie
  movie = Movie.find_or_create_by(tmdb_id: tmdb_movie['id'], letterboxd_slug: letterboxd_film[:slug])
  unless tmdb_movie.nil?
    movie.title = tmdb_movie['title']
    movie.letterboxd_position = position unless position.nil?
    movie.genres = genres
    movie.languages = languages
    movie.companies = companies
    movie.countries = countries
    movie.services = services
    movie.budget = tmdb_movie['budget']
    movie.revenue = tmdb_movie['revenue']
    movie.imdb_id = tmdb_movie['imdb_id']
    movie.tmdb_poster_path = tmdb_movie['poster_path']
    movie.tmdb_backdrop_path = tmdb_movie['backdrop_path']
    movie.tmdb_rating = tmdb_movie['vote_average']
    movie.tmdb_vote_count = tmdb_movie['vote_count']
    movie.release_date = Date.parse(tmdb_movie['release_date']) unless tmdb_movie['release_date'].blank?
    movie.runtime = tmdb_movie['runtime']
    movie.plot = tmdb_movie['overview']
    movie.tagline = tmdb_movie['tagline']
    movie.tmdb_popularity = tmdb_movie['popularity']
    movie.trailer_url = letterboxd_film[:trailer]
    movie.letterboxd_rating = letterboxd_film[:average_rating]
    movie.letterboxd_vote_count = letterboxd_film[:vote_count]
  end
  unless omdb_movie.nil?
    movie.certification = omdb_movie.rated unless omdb_movie.rated.nil?
    movie.imdb_rating = omdb_movie.imdb_rating unless omdb_movie.imdb_rating.nil?
    movie.imdb_vote_count = omdb_movie.imdb_votes unless omdb_movie.imdb_votes.nil?
    movie.metascore = omdb_movie.metascore unless omdb_movie.metascore.nil?

    # Parse awards and prices
    omdb_movie_awards = omdb_movie.awards.downcase unless omdb_movie.awards.nil?
    include_oscars = true if omdb_movie_awards.include? 'oscar'
    include_nominations = true if omdb_movie_awards.include? 'nomination'
    include_wins = true if omdb_movie_awards.include? 'win'

    if include_oscars || include_wins || include_nominations
      if include_oscars
        awards = omdb_movie_awards.split('.')
        # get number of oscars
        oscars = awards.first.downcase
        if oscars.include? 'won'
          movie.oscars = oscars.scan( /\d+/ ).first
        end
      end
      if include_wins && include_nominations
        if awards.nil?
          awards = omdb_movie_awards
        else
          awards = awards.last
        end
        # get number of wins and nominations
        wins_nominations = awards.split('&')
        movie.wins = wins_nominations.first.scan( /\d+/ ).first
        movie.nominations = wins_nominations.last.scan( /\d+/ ).first
      elsif include_nominations
        movie.nominations = omdb_movie.awards.scan( /\d+/ ).first
      end
    end

  end

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

    movie_role = MovieRole.find_or_create_by(person: person, movie: movie, role: actor_role)
    movie_role.character = item['character']
    movie_role.save!
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

  movie.save!
  movie
end