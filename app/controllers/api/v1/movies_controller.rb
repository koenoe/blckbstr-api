class Api::V1::MoviesController < Api::V1::BaseController

  def index

    @movies = []
    (1..10).each do |i|
      movie = Movie.new(title: 'Koen', backdrop: 'https://image.tmdb.org/t/p/original/4a60TZJqwoNPbturNpx1zBKqLAk.jpg')
      @movies << movie
    end

    render(
      json: @movies
    )
  end

  def random

    tmdb_movie = fetch_random
    tmdb_movie = fetch_details(tmdb_movie['id'])

    movie = Movie.new
    movie.backdrop_base_url = @tmdb_config.base_url
    movie.title = tmdb_movie['title']
    movie.imdb_id = tmdb_movie['imdb_id']
    movie.backdrop_path = tmdb_movie['backdrop_path']
    movie.release_date = Date.parse(tmdb_movie['release_date'])

    render(
      json: {
        title: movie.title,
        backdrop_url: movie.backdrop_url(),
        release_year: movie.release_date.strftime('%Y'),
        imdb_id: movie.imdb_id
      }
    )
  end

  private

    def fetch_random

      if @tmdb_movies.blank?
        @tmdb_movies = Rails.cache.fetch('tmdb_movies_random', expires_in: 24.hours) do
          [Tmdb::Movie.popular, Tmdb::Movie.top_rated, Tmdb::Movie.latest, Tmdb::Movie.upcoming, Tmdb::Movie.now_playing].flatten
        end
      end

      tmdb_movie = @tmdb_movies.sample
      if tmdb_movie['backdrop_path'].blank?
        tmdb_movie = fetch_random
      end
      tmdb_movie
    end

    def fetch_details(tmdb_id)
      tmdb_movie = Tmdb::Movie.detail(tmdb_id)
      if tmdb_movie['imdb_id'].blank?
        tmdb_movie = fetch_random
        tmdb_movie = fetch_details(tmdb_movie['id'])
      end
      tmdb_movie
    end

end