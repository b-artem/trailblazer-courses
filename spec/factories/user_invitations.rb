# frozen_string_literal: true

FactoryBot.define do
  factory :user_invitation do
    email { FFaker::Internet.unique.email }
    token { FFaker::Lorem.characters(Constants::Shared::INVITATION_TOKEN_LENGTH) }
  end
end
