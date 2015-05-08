namespace :blckbstr do

  desc "Fetch popular movies of Letterboxd"
  task fetch_popular: :environment do

    films = Letterboxd::Scraper.fetch_popular()

    ActiveRecord::Base.transaction do
      films.each do |film|
        movie = Movie.find_or_create_by(letterboxd_slug: film[:slug])
        movie.title = film[:title]
        movie.save!
      end
    end

  end

end