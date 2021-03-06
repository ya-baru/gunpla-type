Rails.application.routes.draw do
  root 'users/home#index'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  namespace :admins do
    resources :articles
  end

  devise_for :users,
             skip: %i(registrations sessions confirmations unlocks passwords),
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks',
             }

  devise_scope :user do
    get 'signup', to: 'users/registrations#new', as: :new_user_registration
    get 'user/edit', to: 'users/registrations#edit', as: :edit_user_registration
    get 'user/edit_email', to: 'users/registrations#edit_email', as: :edit_email_user_registration
    get 'user/edit_password', to: 'users/registrations#edit_password', as: :edit_password_user_registration
    match 'signup_confirm', to: 'users/registrations#new_confirm', via: %i(get post)
    get 'signout_confirm', to: 'users/registrations#delete_confirm'
    post 'signup', to: 'users/registrations#create', as: :user_registration
    post 'signup', to: 'users/registrations#new', action: :signup_confirm_back
    patch 'user/edit', to: 'users/registrations#update', as: :update_user_registration
    patch 'user/edit_email', to: 'users/registrations#update_email', as: :update_email_user_registation
    patch 'user/edit_password', to: 'users/registrations#update_password', as: :update_password_user_registration
    put 'user', to: 'users/registrations#update', as: nil
    delete 'signout', to: 'users/registrations#destroy', as: :destroy_user_registration

    get 'login', to: 'users/sessions#new', as: :new_user_session
    post 'login', to: 'users/sessions#create', as: :user_session
    delete 'logout', to: 'users/sessions#destroy', as: :destroy_user_session

    get 'password', to: 'users/passwords#new', as: :new_reset_password
    get 'password/edit', to: 'users/passwords#edit', as: :edit_password
    post 'password', to: 'users/passwords#create', as: :reset_password
    put 'password/edit', to: 'users/passwords#update', as: :user_password
    patch 'password/edit', to: 'users/passwords#update', as: nil

    get 'account_confirmation', to: 'users/confirmations#new', as: :new_account_confirmation
    get 'users/confirmation', to: 'users/confirmations#show', as: :confirmation
    post 'account_confirmation', to: 'users/confirmations#create', as: :account_confirmation

    get 'account_unlock', to: 'users/unlocks#new', as: :new_account_unlock
    get 'users/unlock', to: 'users/unlocks#show', as: :unlock
    post 'account_unlock', to: 'users/unlocks#create', as: :account_unlock
  end

  scope module: :users do
    get 'company', to: 'about#company'
    get 'privacy', to: 'about#privacy'
    get 'term', to: 'about#term'
    get 'questions', to: 'about#questions'

    get 'contact', to: 'contacts#new', as: :new_user_contact
    match 'contact_confirm', to: 'contacts#confirm', via: %i(get post)
    post 'contact', to: 'contacts#create', as: :user_contact
    post 'contact', to: 'contacts#new', action: :contact_confirm_back

    get 'account_confirmation_mail_sent', to: 'completes#account_confirm'
    get 'password_reset_mail_sent', to: 'completes#password_reset'
    get 'unlock_mail_sent', to: 'completes#unlock'

    resources :mypage, only: :show do
      member do
        get :like_reviews, :favorite_gunplas, :following, :followers
      end
    end

    resources :gunplas, except: %i(create update destroy) do
      collection do
        get 'search', to: 'gunplas#search_index'
        get 'autocomplete', to: 'gunplas#autocomplete'
        get 'get_category_children', defaults: { format: 'json' }
        get 'get_category_grandchildren', defaults: { format: 'json' }
        post 'new', to: 'gunplas#create', as: :create
        post '/:gunpla_id/reviews/new', to: "reviews#create", as: :review
      end

      member do
        get 'select_category_index', to: 'gunplas#select_category_index'
        match 'edit', to: 'gunplas#update', via: %i(patch put), as: :update
      end

      resources :reviews, only: :new
    end

    resources :reviews, only: %i(show edit destroy) do
      member do
        match 'edit', to: 'reviews#update', via: %i(patch put), as: :update
      end

      collection do
        post 'upload_image', defaults: { format: 'json' }
      end

      resources :comments, only: :create
    end

    resources :comments, only: :destroy

    resources :likes, only: %i(create destroy)

    resources :favorites, only: %i(create destroy)

    resources :relationships, only: %i(create destroy)

    resources :notifications, only: %i(index update)

    resources :activities, only: :index

    resources :rankings, only: :index

    resources :articles, only: %i(index show)
  end
end
