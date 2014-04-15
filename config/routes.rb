EdgeApp::Application.routes.draw do

  get 'search' => 'search#index'
  get "my_courses" => 'my_courses#index'
  get "user_home" => 'user_home#index'
  post "course_subscription" => 'user_home#subscribe'
  delete "course_subscription/:id" => 'user_home#unsubscribe'
  devise_for :users
   
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get 'dashboard' => 'dashboards#show'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  get 'playlists/:id/courses' => 'playlists#courses'

  # Example resource route (maps HTTP verbs to controller actions automatically):
  resources :products
  resources :playlists

  # STUBS FOR FUTURE ROUTES
  get 'plans' => 'plans#index'
  get 'teams' => 'teams#index'
  get 'corp_home' => 'corp_home#index'
  get 'employees' => 'employees#index'


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