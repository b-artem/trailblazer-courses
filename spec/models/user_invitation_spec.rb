# frozen_string_literal: true

RSpec.describe UserInvitation, type: :model do
  subject { build :user_invitation }

  describe 'fields' do
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:token).of_type(:string) }
  end
end
