# frozen_string_literal: true

module ApiDoc
  module UserInvitations
    extend ::Dox::DSL::Syntax

    document :api do
      resource 'UserInvitations' do
        endpoint '/user_invitations'
        group 'User Invitations'
      end

      group 'User Invitations' do
        desc 'User invitations group'
      end
    end

    document :create do
      action 'Create user invitation'
    end
  end
end
