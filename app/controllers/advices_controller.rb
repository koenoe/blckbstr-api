class AdvicesController < ApplicationController

  def index
  end

  def create

    render(
      json: {
        hash: '[insert hash here]',
        status: 200
      }
    )
  end

end