# frozen_string_literal: true

module ApiDoc
  module Users
    extend ::Dox::DSL::Syntax

    document :api do
      resource 'Users' do
        endpoint '/users'
        group 'Users'
      end

      group 'Users' do
        desc 'Users group'
      end
    end

    document :index do
      action 'Lists all users (except the admin)'
    end

    document :create do
      action 'Create a user'
    end
  end
end
