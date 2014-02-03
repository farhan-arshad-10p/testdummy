Workr::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations", :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get "/sign_up", :to => "registrations#new",   :as => 'sans_invite_new_user_registration'
    get "/sign_up/:invite_code", :to => "registrations#new",   :as => 'invite_new_user_registration'
    post "/sign_up/:invite_code", :to => "registrations#create",   :as => 'invite_user_registration'
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :ratings, only: [:create, :show]
      resources :articles do
        get "related_articles", on: :member
      end
      resources :content_sources
      resources :hosted_files

      resources :viewed_articles, only: [:create]
      resources :flags, only: [:create]
      
      resources :relationships, only: [:index]
      resources :users, only: [:index, :show, :update] do
        resources :collections, only: [:index]
        resources :viewed_articles, only: [:index]
        resources :interests, only: [:index]
        member do
          get "followers"
          get "following"
        end
      end

      resources :avatars, only: [:create]

      resources :collections, only: [:index, :show, :create, :update, :destroy] do
        resources :articles, only: [:index]
      end
      resources :feeds, only: [:index]
      post "set_path" => "feeds#set_path"
      get "get_path" => "feeds#get_path"
    end
  end

  match 'clip', to: 'clip#create', via: [:get]

  root to: 'site#index'
  get '(*foo)' => 'site#index'
end
