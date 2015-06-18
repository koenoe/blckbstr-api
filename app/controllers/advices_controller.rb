class AdvicesController < ApplicationController

  def index
  end

  def create

    return bad_request! if params[:usernames].blank? || !params[:usernames].is_a?(Array)
    validations = params[:usernames].map {|username| Letterboxd::Scraper.user_exist?(username) }
    return bad_request! if validations.include? false

    users = User.where(letterboxd_username: params[:usernames])
    usernames = users.pluck(:letterboxd_username)
    new_usernames = params[:usernames] - usernames | usernames - params[:usernames]

    unless new_usernames.blank?
      new_usernames.map {|username| User.create(letterboxd_username: username, sync_status: User.sync_statuses[:needs_to_sync]) }
      users = User.where(letterboxd_username: usernames + new_usernames)
      usernames = usernames + new_usernames
    end

    users.default.update_all(sync_status: User.sync_statuses[:needs_to_sync])

    needs_to_sync = users.pluck(:sync_status).include? User.sync_statuses[:needs_to_sync]
    return bad_request! if needs_to_sync && params[:email].blank?

    unless needs_to_sync
      advice_movie = Movie.random
    end

    advice = Advice.create
    advice.email = params[:email] unless params[:email].blank?
    advice.users = users
    advice.digest = Digest::SHA1.hexdigest("#{advice.created_at}#{advice.id}")
    advice.status = Advice.statuses[:done] unless needs_to_sync
    advice.movie = advice_movie unless advice_movie.nil?
    advice.save

    render(
      json: {
        hash: advice.digest,
        status: 200
      }
    )
  end

end