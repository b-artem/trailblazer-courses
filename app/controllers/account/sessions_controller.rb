# frozen_string_literal: true

module Account
  class SessionsController < ApplicationController
    include Authentication

    before_action :authorize_access_request!, except: :create

    def create
      endpoint Accounts::Sessions::Operation::Create
    end

    def destroy
      endpoint Accounts::Sessions::Operation::Destroy, payload: payload
    end
  end
end
