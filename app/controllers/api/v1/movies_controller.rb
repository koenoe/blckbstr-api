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

    @tmdb_movies = [Tmdb::Movie.popular, Tmdb::Movie.top_rated, Tmdb::Movie.latest, Tmdb::Movie.upcoming, Tmdb::Movie.now_playing].flatten
    fetch_random_from_tmdb_movies

    if @tmdb_backdrop.blank?
      fetch_random_from_tmdb_movies
    end

    # Fetch details of TMDb movie
    tmdb_movie = Tmdb::Movie.detail(@tmdb_movie['id'])
    tmdb_movie_year = Time.parse(tmdb_movie['release_date']).strftime('%Y')

    movie = Movie.new(title: tmdb_movie['title'], imdb_id: tmdb_movie['imdb_id'], year: tmdb_movie_year, backdrop: @tmdb_backdrop)

    render(
      json: movie
    )
  end

  private
    def fetch_random_from_tmdb_movies
      @tmdb_movie = @tmdb_movies.sample
      @tmdb_backdrop = @tmdb_config.base_url + 'original' + @tmdb_movie['backdrop_path'] unless @tmdb_movie['backdrop_path'].blank?
    end
end