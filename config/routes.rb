ActiveEndpoint::Engine.routes.draw do
  root 'dashboard#index'

  resources :probes, only: [:index, :show, :destroy] do
    get :show_response
  end
  resources :unregistred_probes, only: [:index, :destroy]
end
