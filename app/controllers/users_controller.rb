class UsersController < ApplicationController

  def index
  end

  def validate

    return bad_request! if params[:usernames].blank?

    errors = []
    needs_to_sync = false
    params[:usernames].each do |username|
      # Check if the user exists on Letterboxd.com
      valid = Letterboxd::Scraper.user_exist?(username)

      errors << username unless valid

      # Check if user needs a sync or is present in the database. If not we need to ask for email address.
      user = User.find_by(letterboxd_username: username)
      needs_to_sync = true if user.nil? || user.sync_status == 'needs_to_sync'
    end

    return not_found!(errors) unless errors.blank?

    render(
      json: {
        needs_to_sync: needs_to_sync,
        status: 200
      }
    )
  end

end