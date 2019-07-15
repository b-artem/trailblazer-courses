# frozen_string_literal: true

module Accounts::Sessions::Operation
  class Create < Trailblazer::Operation
    pass Macro::Semantic(success: :created)

    step Contract::Build(constant: Accounts::Sessions::Contract::Create)
    step Contract::Validate(), fail_fast: true

    step Model(User, :find_by, :email)
    step :authenticate
    fail :authentication_error

    step :login
    step :prepare_renderer

    def authenticate(_ctx, model:, params:, **)
      model.authenticate(params[:password])
    end

    def authentication_error(ctx, *)
      ctx[:errors] = { base: [I18n.t('.errors.session.invalid')] }
    end

    def login(ctx, model:, **)
      ctx[:auth] = JWTSessions::Session.new(
        payload: { user_id: model.id },
        namespace: "#{Constants::Shared::JWT_SESSIONS_NAMESPACE}#{model.id}"
      ).login
    end

    def prepare_renderer(ctx, auth:, **)
      ctx[:model] = nil
      ctx[:renderer_options] = {
        meta: { auth: auth }
      }
    end
  end
end
