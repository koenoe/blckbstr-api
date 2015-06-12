class UsersController < ApplicationController

  def index
  end

  def exist

    return bad_request! if params[:username].blank?

    valid = Letterboxd::Scraper.user_exist?(params[:username])

    return not_found! unless valid

    render(
      json: {
        message: 'Valid user.',
        status: 200
      }
    )
  end

end