Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions' }

  get 'users/show'
  root 'pages#home'
  get 'pages/term'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
