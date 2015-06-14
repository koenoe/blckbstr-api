class UsersController < ApplicationController

  def index
  end

  def exist

    return bad_request! if params[:usernames].blank?

    errors = []
    params[:usernames].each do |username|
      valid = Letterboxd::Scraper.user_exist?(username)

      errors << username unless valid
    end

    return not_found!(errors) unless errors.blank?

    render(
      json: {
        message: 'Valid users.',
        status: 200
      }
    )
  end

end