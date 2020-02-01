# frozen_string_literal: true

module UserInvitations::Contract
  class Validate < Reform::Form
    feature Reform::Form::Dry

    property :token, virtual: true

    validation :default do
      required(:token).filled(size?: Constants::Shared::INVITATION_TOKEN_LENGTH)
    end

    validation :exists, if: :default do
      configure do
        def exists?(value)
          UserInvitation.where(token: value).exists?
        end
      end

      required(:token, &:exists?)
    end
  end
end
