Esendex::Engine.routes.draw do
  resources :message_delivered_events, only: [:create], controller: :message_delivered_events
end
