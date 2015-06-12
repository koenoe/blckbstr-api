class MoviesController < ApplicationController

  def index
  end

  def advice
  end

  def random

    movies = Rails.cache.fetch('movies_random', expires_in: 24.hours) do
      Movie.where.not(tmdb_backdrop_path: '', imdb_id: '').limit(1000).order(tmdb_popularity: :desc).order("RAND()")
    end

    movie = movies.sample

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