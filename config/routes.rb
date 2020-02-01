# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[index create destroy]
  resource :reset_password, only: %i[show create update]
  namespace :account do
    resource :password, only: :update
    resource :session, only: %i[create destroy]
  end
  resources :user_invitations, only: %i[create]
  get 'user_invitaions/validate', to: 'user_invitations#validate'
end
