Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Devise routes for authentication
  devise_for :users

  # User management routes
  resources :users, only: [:index, :show, :edit, :update]

  # Curatelado routes
  resources :curatelados do
    member do
      post :select
      post :add_curator
      delete :remove_curator
    end
  end

  # Classifications routes
  resources :classifications, only: [:index] do
    collection do
      post :create_primary
      post :create_secondary
      delete :destroy_primary, path: 'primary/:id'
      delete :destroy_secondary, path: 'secondary/:id'
    end
  end

  # Payments routes
  resources :payments do
    collection do
      get :secondary_classifications
      get :cpf_cnpj_suggestions
      get :partner_details
    end
  end

  # Reimbursements routes
  resources :reimbursements
  
  # Partners routes
  resources :partners

  # Defines the root path route ("/")
  root "payments#index"
end
