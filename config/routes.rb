Esendex::Engine.routes.draw do
  resources :message_delivered_events, only: [:create]
  resources :message_failed_events, only: [:create]
  resources :inbound_messages, only: [:create]
end
