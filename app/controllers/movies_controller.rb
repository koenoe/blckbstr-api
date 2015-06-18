class MoviesController < ApplicationController

  def index
  end

  def random

    movie = Movie.random

    render(
      json: {
        title: movie.title,
        imdb_url: movie.imdb_url,
        tmdb_backdrop_url: movie.tmdb_backdrop_url,
        release_year: movie.release_date.strftime('%Y')
      }
    )
  end

end