class Api::V1::MoviesController < Api::V1::BaseController

  def index

    letterboxd_usernames = params[:usernames] unless params[:usernames].nil?

    if letterboxd_usernames.nil?
      return render json: {
        error: 'Usernames are required.',
        status: 400
      }, status: 400
    end

    # Fetch watchlists of Letterboxd
    watchlists = []
    letterboxd_usernames.each do |username|
      watchlist = Rails.cache.fetch("letterboxd_watchlist_#{username}", expires_in: 1.day) do
        Letterboxd::Scraper.fetch_watchlist(username)
      end
      watchlists << watchlist
    end

    # Find the matches and pick a random movie
    matches = watchlists.inject(:&)
    letterboxd_film = matches.sample

    letterboxd_film = nil # TESTING PURPOSES!!!

    if letterboxd_film.blank?
      # Fetch seen films of Letterboxd
      seen = []
      letterboxd_usernames.each do |username|
        seen_list = Rails.cache.fetch("letterboxd_seen_#{username}", expires_in: 1.day) do
          Letterboxd::Scraper.fetch_seen(username)
        end
        seen << seen_list
      end
      # Flatten all movies and filter out one unique array
      seen = seen.flatten.uniq
      # Fetch all popular movies of Letterboxd (takes a while)
      letterboxd_popular = Rails.cache.fetch('letterboxd_popular', expires_in: 1.week) do
        Letterboxd::Scraper.fetch_popular()
      end
      # If seen is bigger than the popular movies, we don't have anything to watch..
      if letterboxd_popular.size < seen.size
        return render json: {
          error: 'No movies found.',
          status: 404
        }, status: 404
      end
      # Filter out popular movies who are not in seen
      matches = letterboxd_popular - seen
      letterboxd_film = matches.sample
    end

    render(
      json: letterboxd_film
    )
  end

  def random

    tmdb_movie = fetch_random
    tmdb_movie = fetch_details(tmdb_movie['id'])

    render(
      json: {
        title: tmdb_movie['title'],
        backdrop_url: @tmdb_config.base_url + 'original' + tmdb_movie['backdrop_path'],
        release_year: Date.parse(tmdb_movie['release_date']).strftime('%Y'),
        imdb_id: tmdb_movie['imdb_id']
      }
    )
  end

  private

    def fetch_random
      if @tmdb_movies.blank?
        @tmdb_movies = Rails.cache.fetch('tmdb_movies_random', expires_in: 1.week) do
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
      tmdb_movie = Rails.cache.fetch("tmdb_movie_#{tmdb_id}", expires_in: 1.day) do
        tmdb_movie = Tmdb::Movie.detail(tmdb_id)
      end
      if tmdb_movie['imdb_id'].blank?
        tmdb_movie = fetch_random
        tmdb_movie = fetch_details(tmdb_movie['id'])
      end
      tmdb_movie
    end

end