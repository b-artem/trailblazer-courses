# frozen_string_literal: true

module UserInvitations::Contract
  class Create < Reform::Form
    feature Reform::Form::Dry

    property :email

    validation :default do
      required(:email).filled(format?: Constants::Shared::EMAIL_REGEX)
    end

    validation :unique, if: :default do
      configure do
        def unique?(value)
          !User.where(email: value).exists? && !UserInvitation.where(email: value).exists?
        end
      end

      required(:email, &:unique?)
    end
  end
end
