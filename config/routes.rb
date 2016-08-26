Rails.application.routes.draw do
  
  resources :orders
  root "home#index"
  
  resources :items
  resources :cities
  #resources :userprofiles
  resources :deliveries
  resources :roles
  resources :comments
  resources :conversations do
    resources :messages
  end
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations', invitations: 'invitations'}

  get "/style-log" => "userprofiles#styledata"
  get "/confirmation" => "userprofiles#confirmation"
  get "/thank-you" => "users#styledata"
  get "users/start" => "users#start"
  post "users/save-data" => "userprofiles#create"
  post "users/delivery" => "users#deliver"
  get "users/new-signup" => "userprofiles#request_details"
  post "users/new-signup" => "userprofiles#savenumber"
  get "/welcome-user" => "userprofiles#welcomeuser"
  get "/users-check" => "home#newuser"
  # post "/users/leads" => "leads#create"

  # devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  # match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  devise_scope :user do  
    get '/logout' => 'devise/sessions#destroy'     
    get '/users/sign_out' => 'devise/sessions#destroy'     
    get '/login' => 'devise/sessions#new'     
    get '/register' => 'devise/registrations#new'     
    get '/forgotpassword' => 'devise/passwords#new'     
    get '/welcome' => 'devise/confirmations#new'     
  end

  get '/admin/getallorders' => 'admin#getallorders'
  get '/admin/getpendingorders' => 'admin#getpendingorders'
  post '/admin/updatecomment' => 'admin#updatecomment'
  post '/admin/dispatchorder' => 'admin#dispatchorder'
  post '/admin/completeorder' => 'admin#completeorder'
  post '/admin/cancelorder' => 'admin#cancelorder'
  post '/admin/updateuserstylistcomment' => 'admin/updateuserstylistcomment'
  
  
  # Routes for deliveries
  get 'deliveries/index'
  get 'deliveries/show'
  get 'deliveries/schedule'
  post 'deliveries/schedule' => "deliveries#create"
  
  # Routes for stylists
  get 'admin/index' => 'admin#index'
  get 'admin/userprofile/:id' => 'admin#getuserprofile'
  get 'stylist/index'
  get 'stylist/deliveries'

  scope "/stylist" do
    resources :users
    resources :userprofiles
    resources :deliveries
    resources :orders
    
    get "/dashboard"=> "stylist#index"
  end

end
