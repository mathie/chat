Chat::Application.routes.draw do
  resources :messages, only: [ :create ]

  root to: 'pages#index'
end
