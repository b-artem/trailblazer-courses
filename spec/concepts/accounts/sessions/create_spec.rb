# frozen_string_literal: true

RSpec.describe Accounts::Sessions::Operation::Create do
  subject(:result) { described_class.call(params: params) }

  let(:user) { create(:user, password: password) }
  let(:password) { 'MegaPassword0' }
  let(:token) { double(:auth_token) }
  let(:cache_key) { auth_token_key_for(user) }

  before do
    allow(JWTSessions::Session).to receive_message_chain(:new, :login)
      .with(payload: { user_id: user.id }, refresh_by_access_allowed: true)
      .with(no_args)
      .and_return(token)
    result
  end

  describe 'Success' do
    let(:params) { { email: user.email, password: password } }

    it 'creates session token' do
      expect(result[:auth]).to eq(token)
      expect(result).to be_success
    end
  end

  describe 'Failure' do
    shared_examples 'does not create session' do
      it 'does not create session token' do
        expect(result[:auth]).to be_nil
        expect(result).to be_failure
      end
    end

    context 'with blank password' do
      let(:params) { { email: user.email, password: nil } }
      let(:errors) { { password: ["Password can't be blank", 'Use a minimum password length of 6 or more characters'] } }

      include_examples 'does not create session'

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match(errors)
      end
    end

    context 'with wrong password' do
      let(:params) { { email: user.email, password: 'wrong_password' } }
      let(:errors) { { base: ['Email or password is incorrect'] } }

      include_examples 'does not create session'

      it 'has validation errors' do
        expect(result[:errors]).to match(errors)
      end
    end

    context 'with blank email' do
      let(:params) { { email: nil, password: password } }
      let(:errors) { { email: ["Email can't be blank"] } }

      include_examples 'does not create session'

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match(errors)
      end
    end

    context 'with wrong email' do
      let(:params) { { email: 'wrong@example.com', password: password } }
      let(:errors) { { base: ['Email or password is incorrect'] } }

      include_examples 'does not create session'

      it 'has validation errors' do
        expect(result[:errors]).to match(errors)
      end
    end
  end
end
