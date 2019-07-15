# frozen_string_literal: true

module Users::Operation
  class Create < Trailblazer::Operation
    step :find_invitation
    step :token_valid?
    fail :invalid_token

    step Model(User, :new)
    step Contract::Build(constant: Users::Contract::Create)
    step :add_email
    step Contract::Validate(), fail_fast: true
    step Contract::Persist()

    step :destroy_invitation

    def find_invitation(ctx, params:, **)
      ctx[:invitation] = UserInvitation.find_by(token: params[:token])
    end

    def token_valid?(ctx, **)
      ctx[:invitation]
    end

    def invalid_token(ctx, **)
      ctx[:errors] = { token: [I18n.t('errors.invalid_invitation_token')] }
    end

    def add_email(ctx, params:, **)
      params[:email] = ctx[:invitation].email
    end

    def destroy_invitation(ctx, **)
      ctx[:invitation].destroy
    end
  end
end
