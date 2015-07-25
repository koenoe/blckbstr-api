class Movie < ActiveRecord::Base
  has_and_belongs_to_many :languages, join_table: 'movie_languages', class_name: 'Language'
  has_and_belongs_to_many :countries, join_table: 'movie_countries', class_name: 'Country'
  has_and_belongs_to_many :companies, join_table: 'movie_companies', class_name: 'Company'
  has_and_belongs_to_many :services, join_table: 'movie_services', class_name: 'Service'
  has_and_belongs_to_many :genres, join_table: 'movie_genres', class_name: 'Genre'
  has_and_belongs_to_many :views, join_table: 'movie_views', class_name: 'User'

  has_many :movie_roles, class_name: 'MovieRole'
  has_many :roles, through: :movie_roles
  has_many :people, through: :movie_roles
  has_many :likes, :as => :likeable, :dependent => :destroy

  def letterboxd_url
    'http://letterboxd.com/film/' + letterboxd_slug
  end

  def imdb_url
    'http://www.imdb.com/title/' + imdb_id
  end

  def tmdb_url
    'http://www.themoviedb.org/movie/' + tmdb_id
  end

  def tmdb_backdrop_url
    'http://image.tmdb.org/t/p/original' + tmdb_backdrop_path
  end

  def tmdb_poster_url
    'http://image.tmdb.org/t/p/original' + tmdb_poster_path
  end

  def release_year
    release_date.strftime('%Y')
  end

  def trailer_full_url
    "#{trailer_url}?html5=1&amp;rel=0&amp;showinfo=0"
  end

  def directors(limit = 0)
    role = Role.find_by_title('Director')
    movie_roles = MovieRole.includes(:person).where(role: role, movie: self).limit(limit)
    movie_roles
  end

  def writers(limit = 0)
    roles = Role.where("title != 'Actor' AND title != 'Director'")
    movie_roles = MovieRole.includes(:person).where(role: roles, movie: self).limit(limit)
    movie_roles
  end

  def actors(limit = 0)
    roles = Role.where(title: 'Actor')
    movie_roles = MovieRole.includes(:person).where(role: roles, movie: self).limit(limit)
    movie_roles
  end

  def ratings
    ratings = []
    ratings << { name: 'Letterboxd', votes: letterboxd_vote_count, rating_calculate: (letterboxd_rating * 10).round, rating: ApplicationController.helpers.number_with_precision(letterboxd_rating, precision: 1) }
    ratings << { name: 'TMDb', votes: tmdb_vote_count, rating_calculate: (tmdb_rating * 10).round, rating: ApplicationController.helpers.number_with_precision(tmdb_rating, precision: 1) }
    ratings << { name: 'IMDb', votes: imdb_vote_count, rating_calculate: (imdb_rating * 10).round, rating: ApplicationController.helpers.number_with_precision(imdb_rating, precision: 1) }
    ratings
  end

  def self.random
    movies = Rails.cache.fetch('movies_random', expires_in: 24.hours) do
      Movie.where.not(tmdb_backdrop_path: '', imdb_id: '').limit(500).order(tmdb_popularity: :desc).order("RAND()")
    end
    movies.sample
  end

  def as_json(options = {})
    oscars = 0 if oscars.blank?
    {
      title: title,
      release_year: release_year,
      certification: certification,
      tagline: tagline,
      plot: plot,
      runtime: runtime,
      release_date: release_date.strftime('%d %B %Y'),
      trailer_url: trailer_full_url,
      oscars: oscars,
      wins: wins,
      nominations: nominations,
      budget: budget,
      revenue: money_format(revenue),
      budget: money_format(budget),
      letterboxd_url: letterboxd_url,
      imdb_url: imdb_url,
      tmdb_url: tmdb_url,
      tmdb_backdrop_url: tmdb_backdrop_url,
      tmdb_poster_url: tmdb_poster_url,
      countries: countries.pluck(:code).join(', ').downcase,
      languages: languages.pluck(:code).join(', '),
      directors: directors(3).map { |d| d.person.name }.uniq,
      writers: writers(3).map { |w| w.person.name }.uniq,
      actors: actors(3).map { |a| { character: a.character, name: a.person.name, image: a.person.tmdb_profile_url } },
      genres: genres.pluck(:title),
      ratings: ratings
    }
  end

  private
    def money_format(value)
      return '-' if value.blank?
      ApplicationController.helpers.number_to_currency(value, separator: '.', delimiter: ',', precision: 0, unit: '$')
    end
end