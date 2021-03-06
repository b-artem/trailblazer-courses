# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Authentication
  include DefaultEndpoint
  include JWTSessions::RailsAuthorization
end
