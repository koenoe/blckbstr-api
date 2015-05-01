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

    tmdb_movie = Tmdb::Movie.popular.sample

    movie = Movie.new(title: tmdb_movie['title'], backdrop: @tmdb_config.base_url + 'original' + tmdb_movie['backdrop_path'])

    render(
      json: movie
    )
  end
end