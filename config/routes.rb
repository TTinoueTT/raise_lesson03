Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    resources :users
  end
  root to: 'tasks#index'
  resources :tasks do
    post :confirm, action: :confirm_new, on: :new
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

#           Prefix Verb   URI Pattern                          Controller#Action
#      admin_users GET    /admin/users(.:format)               admin/users#index
#                  POST   /admin/users(.:format)               admin/users#create
#   new_admin_user GET    /admin/users/new(.:format)           admin/users#new
#  edit_admin_user GET    /admin/users/:id/edit(.:format)      admin/users#edit
#       admin_user GET    /admin/users/:id(.:format)           admin/users#show
#                  PATCH  /admin/users/:id(.:format)           admin/users#update
#                  PUT    /admin/users/:id(.:format)           admin/users#update
#                  DELETE /admin/users/:id(.:format)           admin/users#destroy
# confirm_new_task POST   /tasks/new/confirm(.:format)         tasks#confirm_new
#            tasks GET    /tasks(.:format)                     tasks#index
#                  POST   /tasks(.:format)                     tasks#create
#         new_task GET    /tasks/new(.:format)                 tasks#new
#        edit_task GET    /tasks/:id/edit(.:format)            tasks#edit
#             task GET    /tasks/:id(.:format)                 tasks#show
#                  PATCH  /tasks/:id(.:format)                 tasks#update
#                  PUT    /tasks/:id(.:format)                 tasks#update
#                  DELETE /tasks/:id(.:format)                 tasks#destroy
#             root GET    /                                    tasks#index
