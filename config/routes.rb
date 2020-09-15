Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks',
  }

  devise_scope :user do
    get 'signup', to: 'users/registrations#new'
    post 'signup_confirm', to: 'users/registrations#confirm_new'
    get 'confirm_email', to: 'users/registrations#confirm_email'
    get 'confirmation_send', to: 'users/confirmations#new'
    get 'password_reset', to: 'users/passwords#new'
    get 'signin', to: 'users/sessions#new'
    get 'password_reset_email', to: 'users/passwords#password_reset_email'
    get 'unlock_email', to: 'users/unlocks#unlock_email'
  end

  controller :pages do
    root 'pages#home'
    get 'term', to: 'pages#term'
  end

  resources :users, only: [:show]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
