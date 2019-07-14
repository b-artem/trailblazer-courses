# frozen_string_literal: true

module Constants
  module Shared
    EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
    PASSWORD_REGEX = %r{(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])[a-zA-Z0-9!\$%&,\(\)\*\+-\.\/;:<=>?\[\\\]\^_{|}~#"@]+}i.freeze
    PASSWORD_MIN_LENGTH = 6
    INVITATION_TOKEN_LENGTH = 24
  end
end
