# frozen_string_literal: true

module UserInvitations::Operation
  class Create < Trailblazer::Operation
    pass Macro::Semantic(success: :created)

    step Policy::Guard(Lib::Policy::AdministratorGuard.new), fail_fast: true

    step Model(UserInvitation, :new)
    step Contract::Build(constant: UserInvitations::Contract::Create)
    step Contract::Validate(), fail_fast: true
    step :add_invitation_token
    step Contract::Persist()

    step :send_invitation_email

    def add_invitation_token(_ctx, model:, **)
      model.token = SecureRandom.base58(Constants::Shared::INVITATION_TOKEN_LENGTH)
    end

    def send_invitation_email(_ctx, model:, **)
      UserMailer.invite(model.email, model.token).deliver_later
    end
  end
end
