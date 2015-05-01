class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_tmdb_config

  def set_tmdb_config
    Tmdb::Api.key(ENV['tmdb_api_key'])
    @tmdb_config = Tmdb::Configuration.new
  end
end
