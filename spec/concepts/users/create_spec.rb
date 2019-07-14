# frozen_string_literal: true

RSpec.describe Users::Operation::Create do
  subject(:result) { described_class.call(params: params) }

  let(:user_invitation) { create(:user_invitation) }
  let(:params) do
    {
      token: token,
      first_name: first_name,
      last_name: last_name,
      password: password,
      password_confirmation: password_confirmation
    }
  end
  let(:token) { user_invitation.token }
  let(:first_name) { FFaker::Name.first_name }
  let(:last_name) { FFaker::Name.last_name }
  let(:password) { 'MegaPassword0' }
  let(:password_confirmation) { password }

  describe 'Success' do
    it 'succeeds' do
      expect(result['result.contract.default']).to be_success
      expect(result).to be_success
    end

    it 'creates a user' do
      expect(result[:model]).to be_instance_of(User)
      expect(result[:model]).to be_persisted
      expect(result[:model].email).to eq(user_invitation.email)
      expect(result[:model].first_name).to eq(first_name)
      expect(result[:model].last_name).to eq(last_name)
    end

    it 'deletes user invitation' do
      result
      expect(UserInvitation.count).to eq(0)
    end
  end

  describe 'Failure' do
    shared_examples 'has validation errors' do
      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context 'when token is invalid' do
      let(:token) { 'invalid' }
      let(:errors) { { token: ['Invalid invitation token'] } }

      it 'has errors' do
        expect(result[:errors]).to match errors
        expect(result).to be_failure
      end
    end

    context 'when first_name is blank' do
      let(:first_name) { nil }
      let(:errors) { { first_name: ["First Name can't be blank"] } }

      include_examples 'has validation errors'
    end

    context 'when last_name is blank' do
      let(:last_name) { nil }
      let(:errors) { { last_name: ["Last Name can't be blank"] } }

      include_examples 'has validation errors'
    end

    context 'when password is blank' do
      let(:password) { nil }
      let(:errors) { { password: ["Password can't be blank", "Use a minimum password length of 6 or more characters"] } }

      include_examples 'has validation errors'
    end

    context 'when password is too short' do
      let(:password) { '1Aa$' }
      let(:errors) { { password: ['Use a minimum password length of 6 or more characters'] } }

      include_examples 'has validation errors'
    end

    context 'when password confirmation does not match' do
      let(:password_confirmation) { '123' }
      let(:errors) { { password_confirmation: ['Password and password confirmation do not match'] } }

      include_examples 'has validation errors'
    end

    context 'when email is not unique' do
      before { create(:user, email: user_invitation.email) }

      let(:errors) { { email: ['User with such email already exists'] } }

      include_examples 'has validation errors'
    end
  end
end
