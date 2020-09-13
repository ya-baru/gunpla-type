Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions', registrations: 'users/registrations',
  }

  devise_scope :user do
    get 'confirm_email', to: 'users/registrations#confirm_email'
    post 'users/signup/confirm', to: 'users/registrations#confirm_new'
  end

  controller :pages do
    root 'pages#home'
    get 'term', to: 'pages#term'
  end

  resources :users, only: [:show]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
