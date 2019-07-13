# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[index destroy]
  resource :reset_password, only: %i[show create update]
  namespace :account do
    resource :password, only: :update
  end
  resources :user_invitations, only: %i[create]
end
