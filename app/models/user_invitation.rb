# frozen_string_literal: true

class UserInvitation < ApplicationRecord
  has_secure_token
end
