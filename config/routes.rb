Rails.application.routes.draw do
  
  root "home#index"
 
  resources :orders
  resources :cities
  resources :userprofiles
  resources :roles
  resources :vendors  
  resources :sizes  
  resources :brands  
  resources :fabrics  
  resources :item_statuses
  resources :product_categories
  resources :products
  

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
  get "/orders/:id/feedback" => "orders#get_feedback"
  post "/orders/submit_feedback" => "orders#save_feedback"
  post "/orders/update_status" => "orders#update_status"
  
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
  post '/admin/updateuserstylistcomment' => 'admin#updateuserstylistcomment'
  post '/admin/new_order' => 'admin#backendorder'
  post '/admin/update_order_status' => 'admin#update_order_status'
  post '/admin/get_order_history' => 'admin#get_order_history'
  post '/admin/get_contact_history' => 'admin#get_contact_history'
  post '/admin/next_call' => 'admin#next_call'
  post '/admin/assign_stylist' => 'admin#assign_stylist'
  post '/admin/mark_box_ready_items' => 'admin#mark_box_ready_items', :as => :box_ready_items
  
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
