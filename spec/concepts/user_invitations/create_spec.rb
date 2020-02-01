# frozen_string_literal: true

RSpec.describe UserInvitations::Operation::Create do
  subject(:result) { described_class.call(current_user: user, params: params) }

  let(:user) { create(:user, is_admin: is_admin) }
  let(:is_admin) { true }
  let(:params) { { email: FFaker::Internet.unique.email } }

  describe 'Success' do
    context 'when email is not registered' do
      it 'succeeds' do
        expect(result[:success_semantic]).to eq(:created)
        expect(result).to be_success
      end

      it 'creates UserInvitation' do
        expect(result[:model]).to be_instance_of(UserInvitation)
        expect(result[:model]).to be_persisted
        expect(result[:model].email).to eq(params[:email])
      end

      it 'generates invitation token' do
        expect(result[:model].token).to be_present
      end

      it 'sends invitation email' do
        allow_any_instance_of(UserInvitation).to receive(:regenerate_token)
          .and_return('fake_token')
        expect(UserMailer).to receive_message_chain(:invite, :deliver_later)
          .with(params[:email], 'fake_token').with(no_args)
        result
      end
    end
  end

  describe 'Failure' do
    context 'when current_user is not an administrator' do
      let(:is_admin) { false }

      it 'breaches policy' do
        expect(result['result.policy.default']).to be_failure
        expect(result).to be_failure
      end
    end

    context 'with empty params' do
      let(:params) { {} }
      let(:errors) { { email: ['must be filled'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context "when email doesn't match regex" do
      let(:params) { { email: 'wrong_email' } }
      let(:errors) { { email: ['is in invalid format'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context 'when user already exists' do
      let(:params) { { email: user.email } }
      let(:errors) { { email: ['User with such email already exists'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context 'when user invitation already exists' do
      let(:user_invitation) { create :user_invitation }
      let(:params) { { email: user_invitation.email } }
      let(:errors) { { email: ['User with such email already exists'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end
  end
end
