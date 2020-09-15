Rails.application.routes.draw do
  devise_for :users,
             skip: [:registrations, :sessions, :confirmations],
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks',
               # registrations: 'users/registrations',
               # sessions: 'users/sessions',
               # confirmations: 'users/confirmations',
               passwords: 'users/passwords',
               unlocks: 'users/unlocks',
             }

  devise_scope :user do
    get 'signup', to: 'users/registrations#new', as: :new_user_registration
    post 'signup', to: 'users/registrations#create', as: :user_registration
    get 'user/edit', to: 'users/registrations#edit', as: :edit_user_registration
    put 'user', to: 'users/registrations#update', as: :update_user_registration
    patch 'user', to: 'users/registrations#update', as: nil
    delete 'user', to: 'users/registrations#destroy', as: :destroy_user_registration
    get 'signup/cancel', to: 'users/registrations#cancel', as: :cancel_user_registration
    match 'signup_confirm', to: 'users/registrations#confirm_new', via: [:get, :post]
    post 'signup_confirm_back', to: 'users/registrations#confirm_back'
    post 'signup', to: 'users/registrations#new', action: :signup_confirm_back
    get 'account_confirmation_mail_sent', to: 'users/registrations#mail_sent'

    get 'login', to: 'users/sessions#new', as: :new_user_session
    post 'login', to: 'users/sessions#create', as: :user_session
    delete 'logout', to: 'users/sessions#destroy', as: :destroy_user_session

    get 'password', to: 'users/passwords#new', as: :new_reset_password
    post 'password', to: 'users/passwords#create', as: :reset_password
    # get 'password/edit', to: 'users/passwords#edit', as: :edit_user_password
    # patch 'password', to: 'users/passwords#update'
    # put 'password', to: 'users/passwords#update', as: :update_user_password
    get 'password_reset_mail_sent', to: 'users/passwords#mail_sent'

    get 'account_confirmation', to: 'users/confirmations#new', as: :new_account_confirmation
    post 'account_confirmation', to: 'users/confirmations#create', as: :account_confirmation
    get 'users/confirmation', to: 'users/confirmations#show', as: :user_confirmation

    get 'account_unlock', to: 'users/unlocks#new', as: :new_account_unlock
    post 'account_unlock', to: 'users/unlocks#create', as: :account_unlock
    get 'unlock_mail_sent', to: 'users/unlocks#mail_sent'
  end

  controller :pages do
    root 'pages#home'
    get 'term', to: 'pages#term'
  end

  resources :users, only: [:show]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
