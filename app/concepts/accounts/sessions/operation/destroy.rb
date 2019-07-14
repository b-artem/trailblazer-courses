# frozen_string_literal: true

module Accounts::Sessions::Operation
  class Destroy < Trailblazer::Operation
    step :destroy_sessions

    def destroy_sessions(_ctx, payload:, **)
      session = JWTSessions::Session.new
      session.flush_by_uid(payload['ruid'])
    end
  end
end
