class StatusController < ApplicationController

  def index
    render json: {
      message: 'Everything is up!',
      status: 200
    }, status: 200
  end

end