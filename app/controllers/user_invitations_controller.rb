# frozen_string_literal: true

class UserInvitationsController < ApplicationController
  include Authentication

  before_action :authorize_access_request!, except: :validate

  def create
    endpoint UserInvitations::Operation::Create, current_user: current_user
  end

  def validate
    endpoint UserInvitations::Operation::Validate
  end
end
