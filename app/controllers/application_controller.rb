class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_filter :destroy_session, :set_tmdb_config

  def destroy_session
    request.session_options[:skip] = true
  end

  def set_tmdb_config
    Tmdb::Api.key(ENV['tmdb_api_key'])
    @tmdb_config = Tmdb::Configuration.new
  end

  def not_found!(errors = nil)
    render(
      json: {
        message: 'Not found.',
        errors: errors,
        status: 404
      },
      status: 404
    )
  end

  def bad_request!(errors = nil)
    render(
      json: {
        message: 'Bad request.',
        errors: errors,
        status: 400
      },
      status: 400
    )
  end

  # def api_error(status: 500, errors: [])
  #   unless Rails.env.production?
  #     puts errors.full_messages if errors.respond_to? :full_messages
  #   end
  #   head status: status and return if errors.empty?

  #   api_error(status: 500, errors: errors)
  # end
end
