require 'chat_stream'

Chat::Application.routes.draw do
  mount ChatStream, at: '/chat'
  root to: 'pages#index'
end
