NicksListAdminProj::Application.routes.draw do
  
  post "/reports/ViewFAQ"
  get"/reports/ViewFAQ"
  post "/reports/ViewTestimonials"
  get"/reports/ViewTestimonials"
  post "/reports/ViewNewsUpdate"
  get"/reports/ViewNewsUpdate"
  post "/reports/ViewSiteContent"
  get"/reports/ViewSiteContent"
  post "/reports/ViewMLJudgements"
  get"/reports/ViewMLJudgements"
  post "/reports/ViewCourtProceedings"
  get "/reports/ViewCourtProceedings"
  post "/reports/AdminActivityReport"
  get"/reports/AdminActivityReport"
  post "/reports/AdminActivityDetails"
  get "/reports/AdminActivityDetails"
  post "/reports/ViewReview"
  get "/reports/ViewReview"
  post "/reports/ViewUser"
  get "/reports/ViewUser"
  post "/reports/ViewAdmin"
  get "/reports/ViewAdmin"
  post "/reports/ViewCustomerSearchBy"
  get "/reports/ViewCustomerSearchBy"
  post "/reports/CustomerSearchReport"
  get "/reports/CustomerSearchReport"
  post "/reports/UserLoginReport"
  get "/reports/UserLoginReport"
  post "/reports/AdminLoginReport"
  get "/reports/AdminLoginReport"
  post "/reports/ViewUserLoginHistory"
  get "/reports/ViewUserLoginHistory"
  post "/reports/ViewAdminLoginHistory"
  get "/reports/ViewAdminLoginHistory"
  
  post "/sitecontent/EnableDisableFAQ"
  get "/sitecontent/EnableDisableFAQ"
  post "/sitecontent/AddFAQPage"
  get "/sitecontent/AddFAQPage"
  post "/sitecontent/AddUpdateFAQPage"
  get "/sitecontent/AddUpdateFAQPage"
  post "/sitecontent/DeleteFAQPage"
  get "/sitecontent/DeleteFAQPage"
  post "/sitecontent/EditFAQPage"
  get "/sitecontent/EditFAQPage"
  post "/sitecontent/ManageFAQPage"
  get "/sitecontent/ManageFAQPage"
  
  post "/sitecontent/EnableDisableNewsUpdate"
  get "/sitecontent/EnableDisableNewsUpdate"
  post "/sitecontent/AddNewsUpdatePage"
  get "/sitecontent/AddNewsUpdatePage"
  post "/sitecontent/AddUpdateNewsUpdatePage"
  get "/sitecontent/AddUpdateNewsUpdatePage"
  post "/sitecontent/DeleteNewsUpdatePage"
  get "/sitecontent/DeleteNewsUpdatePage"
  post "/sitecontent/EditNewsUpdatePage"
  get "/sitecontent/EditNewsUpdatePage"
  post "/sitecontent/ManageNewsUpdatePage"
  get "/sitecontent/ManageNewsUpdatePage"
  
  post "/sitecontent/EnableDisableTestimonials"
  get "/sitecontent/EnableDisableTestimonials"
  post "/sitecontent/AddTestimonialsPage"
  get "/sitecontent/AddTestimonialsPage"
  post "/sitecontent/AddUpdateTestimonialsPage"
  get "/sitecontent/AddUpdateTestimonialsPage"
  post "/sitecontent/DeleteTestimonialsPage"
  get "/sitecontent/DeleteTestimonialsPage"
  post "/sitecontent/EditTestimonialsPage"
  get "/sitecontent/EditTestimonialsPage"
  post "/sitecontent/ManageTestimonialsPage"
  get "/sitecontent/ManageTestimonialsPage"
  
  post "/sitecontent/UpdateSiteContent"
  get "/sitecontent/UpdateSiteContent"
  
  post "/sitecontent/EditAboutPage"
  get "/sitecontent/EditAboutPage"
  
  post "/sitecontent/EditHowItWorksPage"
  get "/sitecontent/EditHowItWorksPage"
  
  post "/sitecontent/EditPressReleasePage"
  get "/sitecontent/EditPressReleasePage"
  
  post "/sitecontent/EditPrivacyPolicy"
  get "/sitecontent/EditPrivacyPolicy"
  
  post "/sitecontent/EditTermsConditions"
  get "/sitecontent/EditTermsConditions"
  
  post "/public_records/UpdateCourtProceedings"
  get "/public_records/UpdateCourtProceedings"
  post "/public_records/EditCourtProceedings"
  get "/public_records/EditCourtProceedings"
  
  post "/public_records/UpdateMLJudgements"
  get "/public_records/UpdateMLJudgements"
  post "/public_records/EditMLJudgements"
  get "/public_records/EditMLJudgements"
  
  post "/public_records/ManagePublicRecords"
  get "/public_records/ManagePublicRecords"
  
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
  
  post "/users/ChangePassword"
  get "/users/ChangePassword"
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
  post "/reviews/EditReview"
  get "/reviews/EditReview"
  post "/reviews/UpdateReview"
  get "/reviews/UpdateReview"
  post "/reviews/PublishReview"
  get "/reviews/PublishReview"
  post "/reviews/ApproveReview"
  get "/reviews/ApproveReview"
  
  post "/user_profile/EditProfile"
  get "/user_profile/EditProfile"
  post "/user_profile/ViewProfile"
  get "/user_profile/ViewProfile"
  post "/user_profile/UpdateProfile"
  get "/user_profile/UpdateProfile"
    
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
