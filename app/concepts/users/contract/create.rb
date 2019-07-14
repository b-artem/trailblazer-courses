# frozen_string_literal: true

module Users::Contract
  class Create < Reform::Form
    feature Reform::Form::Dry

    property :email
    property :first_name
    property :last_name
    property :password, readable: false
    property :password_confirmation, virtual: true

    validation :default do
      configure do
        config.namespace = :user_create
      end

      required(:email).filled(format?: Constants::Shared::EMAIL_REGEX)
      required(:first_name).filled(:str?)
      required(:last_name).filled(:str?)
      required(:password).filled(
        :str?,
        format?: Constants::Shared::PASSWORD_REGEX,
        min_size?: Constants::Shared::PASSWORD_MIN_LENGTH
      ).confirmation
    end

    validation :unique, if: :default do
      configure do
        def unique?(value)
          !User.where(email: value).exists?
        end
      end

      required(:email, &:unique?)
    end
  end
end
