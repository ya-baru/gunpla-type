Rails.application.routes.draw do
  devise_for :users,
    skip: [:registrations, :sessions],
    controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    # registrations: 'users/registrations',
    # sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks',
  }

  devise_scope :user do
    get 'confirmation_send', to: 'users/confirmations#new'
    # get 'password_reset', to: 'users/passwords#new'
    get 'unlock_email', to: 'users/unlocks#unlock_email'


    get 'signup', to: 'users/registrations#new', as: :new_user_registration
    post 'signup', to: 'users/registrations#create', as: :user_registration
    get 'user/edit', to: 'users/registrations#edit', as: :edit_user_registration
    patch 'user', to: 'users/registrations#update', as: nil
    put 'user', to: 'users/registrations#update', as: :update_user_registration
    delete 'user', to: 'users/registrations#destroy', as: :destroy_user_registration
    get 'signup/cancel', to: 'users/registrations#cancel', as: :cancel_user_registration
    match 'signup_confirm', to: 'users/registrations#confirm_new', via: [:get, :post]
    post 'signup_confirm_back', to: 'users/registrations#confirm_back'
    post 'signup', to: 'users/registrations#new', action: :signup_confirm_back
    get 'registration_complet', to: 'users/registrations#complet'

    get 'login', to: 'users/sessions#new', as: :new_user_session
    post 'login', to: 'users/sessions#create', as: :user_session
    delete 'logout', to: 'users/sessions#destroy', as: :destroy_user_session

    # get 'password', to: 'users/passwords#new', as: :new_user_password
    # post 'password', to: 'users/passwords#create', as: :user_password
    # get 'password_reset_sent', to: 'users/passwords#password_reset_email'
    # get 'password/edit', to: 'users/passwords#edit', as: :edit_user_password
    # patch 'password', to: 'users/passwords#update'
    # put 'password', to: 'users/passwords#update', as: :update_user_password
  end


  controller :pages do
    root 'pages#home'
    get 'term', to: 'pages#term'
  end

  resources :users, only: [:show]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
