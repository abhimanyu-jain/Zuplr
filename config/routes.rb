Rails.application.routes.draw do
  
  get 'admin/index'

  root "home#index"
  
  resources :userprofiles
  resources :roles
  devise_for :users, class_name: 'FormUser', :controllers => { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations'}
  
  scope "/admin" do
    get "/dashboard"=> "admin#index"
    resources :users 
    resources :roles
    resources :userprofiles
  end
  
  get "/style-log" => "userprofiles#styledata"
  get "/thank-you" => "users#styledata"
  get "users/start" => "users#start"
  post "users/save-data" => "userprofiles#create"
  post "users/delivery" => "users#deliver"
  get "users/new-signup" => "userprofiles#justin"
  post "users/new-signup" => "userprofiles#savenumber"

  # devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  # match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  devise_scope :user do  
    get '/logout' => 'devise/sessions#destroy'     
    get '/users/sign_out' => 'devise/sessions#destroy'     
    get '/login' => 'devise/sessions#new'     
    get '/register' => 'devise/registrations#new'     
    get '/forgotpassword' => 'devise/passwords#new'     
    get '/confirmation' => 'devise/confirmations#new'     
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
