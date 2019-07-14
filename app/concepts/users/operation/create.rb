# frozen_string_literal: true

module Users::Operation
  class Create < Trailblazer::Operation
    step :token_valid?
    fail :invalid_token

    step Model(User, :new)
    step Contract::Build(constant: Users::Contract::Create)
    step :add_email
    step Contract::Validate(), fail_fast: true
    step Contract::Persist()

    step :destroy_invitation

    def token_valid?(_ctx, params:, **)
      UserInvitation.where(token: params[:token]).exists?
    end

    def invalid_token(ctx, **)
      ctx[:errors] = { token: [I18n.t('errors.invalid_invitation_token')] }
    end

    def add_email(_ctx, params:, **)
      params[:email] = UserInvitation.find_by(token: params[:token]).email
    end

    def destroy_invitation(_ctx, params:, **)
      UserInvitation.find_by(token: params[:token]).destroy
    end
  end
end
