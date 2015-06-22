Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'home#index'

  # Api routing
  scope '/v1' do

    get '' => 'status#index'

    resources :advices, only: [:show, :create]

    scope :movies do
      get 'random' => 'movies#random'
    end

    scope :users do
      get 'validate' => 'users#validate'
    end
  end

end
