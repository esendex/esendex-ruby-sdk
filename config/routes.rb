Esendex::Engine.routes.draw do
  resources :message_delivered_events, only: [:create]
end
