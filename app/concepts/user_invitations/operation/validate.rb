# frozen_string_literal: true

module UserInvitations::Operation
  class Validate < Trailblazer::Operation
    step Contract::Build(constant: UserInvitations::Contract::Validate)
    step Contract::Validate()
  end
end
