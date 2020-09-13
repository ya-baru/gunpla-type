Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions', registrations: 'users/registrations',
  }

  devise_scope :user do
    get 'confirm_email', to: 'users/registrations#confirm_email'
  end

  resources :users, only: [:show]
  root 'pages#home'
  get 'pages/term'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
