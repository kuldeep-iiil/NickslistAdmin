NicksListAdminProj::Application.routes.draw do
  post "/site_users/AddUser"
  get "/site_users/AddUser"
  post "/site_users/ManageUsers"
  get "/site_users/ManageUsers"
  post "/site_users/EditUser"
  get "/site_users/EditUser"
  post "/site_users/UpdateUser"
  get "/site_users/UpdateUser"
  post "/site_users/EditRoles"
  get "/site_users/EditRoles"
  post "/site_users/AddUpdateRoles"
  get "/site_users/AddUpdateRoles"
  post "/site_users/ChangePassword"
  get "/site_users/ChangePassword"
  post "/site_users/UserActivation"
  get "/site_users/UserActivation"
  post "/users/AddUser"
  get "/users/AddUser"
  post "/users/ManageUsers"
  get "/users/ManageUsers"
  post "/users/EditUser"
  get "/users/EditUser"
  post "/users/UpdateUser"
  get "/users/UpdateUser"
  post "/users/UserActivation"
  get "/users/UserActivation"
  post "/reviews/ManageReviews"
  get "/reviews/ManageReviews"
  post "/sitecontent/ManageContent"
  get "/sitecontent/ManageContent"
  post "/user_profile/EditProfile"
  get "/user_profile/EditProfile"
  post "/user_profile/ViewProfile"
  get "/user_profile/ViewProfile"
  post "/user_profile/UpdateProfile"
  get "/user_profile/UpdateProfile"
  
  post "/review_customers/PrevNextReview"
  get "/review_customers/PrevNextReview"
  post "/review_customers/TermsConditions"
  get "/review_customers/TermsConditions"
  post "/review_customers/UpdateReviewData"
  get "/review_customers/UpdateReviewData"
  post "/review_customers/UpdateReviews"
  get "/review_customers/UpdateReviews"
  post "/review_customers/AddReviewData"
  get "/review_customers/AddReviewData"
  post "/review_customers/AddReviews"
  get "/review_customers/AddReviews"
  post "/review_customers/ListReviews"
  get "/review_customers/ListReviews"
  post "/review_customers/ReadReviews"
  get "/review_customers/ReadReviews"
  
  post "/authentication/ChangePassword"
  get "/authentication/ChangePassword"
  post "/authentication/SavePassword"
  get "/authentication/SavePassword"
  post "/authentication/requestpassword"
  get "/authentication/requestpassword"
  post "/authentication/login"
  get "/authentication/login"
  post "/authentication/logout"
  get "/authentication/logout"
  post "/customer_search/LoadReviews"
  get "/customer_search/LoadReviews"
  post "/nicks_admin/Index"
  get "/nicks_admin/Index"
  root to: "nicks_admin#Index"
  
  resources :orders do
    collection do
      get :paid
      get :revoked
      post :ipn
    end
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
