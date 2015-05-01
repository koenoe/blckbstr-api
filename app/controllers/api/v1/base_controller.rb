class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  before_filter :destroy_session, :set_tmdb_config

  def destroy_session
    request.session_options[:skip] = true
  end

  def set_tmdb_config
    Tmdb::Api.key(ENV['tmdb_api_key'])
    @tmdb_config = Tmdb::Configuration.new
  end

  def invalid_resource!(errors = [])
    api_error(status: 422, errors: errors)
  end

  def not_found!
    api_error(status: 404, errors: 'Not found')
  end

  def api_error(status: 500, errors: [])
    unless Rails.env.production?
      puts errors.full_messages if errors.respond_to? :full_messages
    end
    head status: status and return if errors.empty?

    api_error(status: 500, errors: errors)
  end

end