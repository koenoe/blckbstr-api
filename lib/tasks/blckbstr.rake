namespace :blckbstr do

  desc "Fetch popular movies of Letterboxd"
  task fetch_popular: :environment do

    Rails.cache.fetch('letterboxd_popular', expires_in: 1.week) do
      Letterboxd::Scraper.fetch_popular()
    end

  end

end