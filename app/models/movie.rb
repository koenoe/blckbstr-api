class Movie
  include ActiveModel::Model

  attr_accessor :title,
                :release_date,
                :imdb_id,
                :backdrop_path,
                :backdrop_base_url

  def backdrop_url(size = 'original')
    if self.backdrop_base_url.blank?
      self.backdrop_base_url = 'http://image.tmdb.org/t/p/'
    end
    self.backdrop_base_url + size + self.backdrop_path
  end

end