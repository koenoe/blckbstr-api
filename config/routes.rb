Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # Api routing
  namespace :api do
    namespace :v1 do
      scope :movies do
        get '' => 'movies#index'
        get 'random' => 'movies#random'
      end
    end
  end

end
