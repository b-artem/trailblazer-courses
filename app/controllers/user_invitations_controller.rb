# frozen_string_literal: true

class UserInvitationsController < AuthorizedController
  def create
    endpoint UserInvitations::Operation::Create, current_user: current_user
  end
end
