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
    @movie = Movie.new(title: 'Edwin', backdrop: 'https://image.tmdb.org/t/p/original/9IkNvxjwn1fr8MW9PUoOkbZvYNX.jpg')
    render(
      json: @movie
    )
  end
end