require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  resources :auto_replies
  mount Sidekiq::Web => "/sidekiq"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  resources :incidents, only: [ :index, :show ]

  resources :hospitable_webhooks, only: [ :create ]

  resources :waapi_webhooks, only: [ :create ]
  resources :clickup_webhooks, only: [ :create ]

  resources :auto_replies
  resources :sandbox_auto_replies, only: [ :index, :create ]

  resources :open_ai_requests, only: [ :index, :show ]
  resources :properties, only: [ :index, :show ]

  get "escalate/:token", to: "incident_escalations#show", as: :incident_escalation

  root "incidents#index"
end
