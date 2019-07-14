# frozen_string_literal: true

module Account
  class SessionsController < ApplicationController
    def create
      endpoint Accounts::Sessions::Operation::Create
    end
  end
end
