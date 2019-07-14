# frozen_string_literal: true

RSpec.describe UserInvitations::Operation::Validate do
  subject(:result) { described_class.call(params: params) }

  let(:user_invitation) { create(:user_invitation) }
  let(:params) { { token: token } }
  let(:token) { user_invitation.token }

  describe 'Success' do
    context 'when user invitation exists' do
      it 'succeeds' do
        expect(result).to be_success
      end
    end
  end

  describe 'Failure' do
    context 'with empty params' do
      let(:params) { {} }
      let(:errors) { { token: ['must be filled', 'size must be 24'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context 'when token is too short' do
      let(:token) { 'short' }
      let(:errors) { { token: ['length must be 24'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context 'when user invitation does not exist' do
      let(:token) { FFaker::Lorem.characters(24) }
      let(:errors) { { token: ["That user invitation doesn't exist"] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end
  end
end
