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

  def tmdb_backdrop_url
    'http://image.tmdb.org/t/p/original' + tmdb_backdrop_path
  end

  def tmdb_poster_url
    'http://image.tmdb.org/t/p/original' + tmdb_poster_path
  end

  def release_year
    release_date.strftime('%Y')
  end

  def directors
    role = Role.find_by_title('Director')
    movie_roles = MovieRole.includes(:person).where(role: role, movie: self)
    movie_roles
  end

  def writers
    roles = Role.where("title != 'Actor' AND title != 'Director'")
    movie_roles = MovieRole.includes(:person).where(role: roles, movie: self)
    movie_roles
  end

  def self.random
    movies = Rails.cache.fetch('movies_random', expires_in: 24.hours) do
      Movie.where.not(tmdb_backdrop_path: '', imdb_id: '').limit(500).order(tmdb_popularity: :desc).order("RAND()")
    end
    movies.sample
  end

  def as_json(options = {})
    super(
      methods: [:letterboxd_url, :imdb_url, :tmdb_backdrop_url, :tmdb_poster_url, :release_year],
      except: [:id, :letterboxd_slug, :tmdb_backdrop_path, :tmdb_poster_path, :created_at, :updated_at],
      include: {
        genres: {
          except: [:id, :created_at, :updated_at]
        },
        languages: {
          except: [:id, :created_at, :updated_at]
        },
        countries: {
          except: [:id, :created_at, :updated_at]
        },
        movie_roles: {
          except: [:id, :movie_id, :person_id, :role_id, :created_at, :updated_at],
          include: {
            person: {
              except: [:id, :created_at, :updated_at, :tmdb_profile_path, :place_of_birth, :birthdate, :deathdate],
              methods: [:tmdb_profile_url]
            },
            role: {
              except: [:id, :created_at, :updated_at]
            }
          }
        }
      }
    )
  end
end