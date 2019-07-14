# frozen_string_literal: true

module ApiDoc
  module Account
    module Sessions
      extend ::Dox::DSL::Syntax

      document :api do
        resource 'Session' do
          endpoint '/account/session'
          group 'User Session'
        end

        group 'User Session' do
          desc 'User session'
        end
      end

      document :create do
        action 'Create a user session'
      end

      document :destroy do
        action 'Destroy a user session'
      end
    end
  end
end
