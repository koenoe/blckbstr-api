class AdvicesController < ApplicationController

  def index
  end

  def create

    # We need to validate the usernames obviously, if something is wrong just return a bad request
    return bad_request! if params[:usernames].blank? || !params[:usernames].is_a?(Array)
    validations = params[:usernames].map {|username| Letterboxd::Scraper.user_exist?(username) }
    return bad_request! if validations.include? false

    # Check if the users exists in our database, if not create them with needs_to_sync status so the cronjob will pick them up
    users = User.where(letterboxd_username: params[:usernames])
    usernames = users.pluck(:letterboxd_username)
    new_usernames = params[:usernames] - usernames | usernames - params[:usernames]

    unless new_usernames.blank?
      new_usernames.map {|username| User.create(letterboxd_username: username, sync_status: User.sync_statuses[:needs_to_sync]) }
      users = User.where(letterboxd_username: usernames + new_usernames)
      usernames = usernames + new_usernames
    end

    # Maybe we have some users already in our database, but not active (an active user can follow those for example).
    # Update these users to needs_to_sync
    users.default.update_all(sync_status: User.sync_statuses[:needs_to_sync])

    # If one of our users needs a sync, we can't give advice right away. In that case they will receive advice by email.
    needs_to_sync = users.pluck(:sync_status).include? User.sync_statuses[:needs_to_sync]
    # Obviously we need an email address if any of the users need a sync. Otherwise just return a bad request.
    return bad_request! if needs_to_sync && params[:email].blank?

    # We can only retrieve a movie for this advice if all the requested users are synced.
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
        email: advice.email.present?,
        status: 200
      }
    )
  end

end