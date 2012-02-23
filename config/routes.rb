Dmtraining::Application.routes.draw do

  resources :s3_uploads

  #resources :skills,   :only => [:index, :create, :destroy]
  resources :sessions, :only => [:new, :create, :destroy]
  resources :users, :only => [:new,:create,:index,:update]
  
  root :to => 'pages#home'
  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/linkinfo', :to => 'lessons#link_info'
  
  scope "/training" do
    
    resources :lessons
    resources :challenges
    resources :skills, :only => [:index,:create,:update,:destroy]
    resources :submissions

    match '/', :to => 'skills#index', :as => 'training_index'
    match '/organize', :to  => 'skills#organize', :as => 'organize_skills'

    scope '/:slug', :slug => /.*/, do

      resources :lessons, :only => [:show,:new,:edit,:destroy],
                :as => "categorized_lesson"
      resources :challenges, :only => [:show,:new,:edit,:destroy],
                :as => "categorized_challenge"

      match '/', :to => "skills#show", :as => "named_skill"
    end
  end
  
  
  match '/gallery', :to => 'pages#gallery', :as => 'gallery_index'
  match '/upload/:type', :to => 'pages#upload', :type => /images|lesson-assets|challenge-assets/, :as => 'upload_index'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
