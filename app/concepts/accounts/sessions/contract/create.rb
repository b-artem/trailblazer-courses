# frozen_string_literal: true

module Accounts::Sessions::Contract
  class Create < Reform::Form
    feature Reform::Form::Dry

    property :email, virtual: true
    property :password, readable: false, virtual: true

    validation do
      configure do
        config.namespace = :user_session
      end

      required(:email).filled(format?: Constants::Shared::EMAIL_REGEX)
      required(:password).filled(:str?, min_size?: Constants::Shared::PASSWORD_MIN_LENGTH)
    end
  end
end
