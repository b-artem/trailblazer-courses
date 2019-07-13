# frozen_string_literal: true

module ResetPasswords::Contract
  class Create < Reform::Form
    feature Reform::Form::Dry

    property :email, virtual: true

    validation do
      required(:email).filled(format?: Constants::Shared::EMAIL_REGEX)
    end
  end
end
