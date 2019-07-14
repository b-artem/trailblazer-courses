# frozen_string_literal: true

RSpec.describe 'Account::Sessions', :dox, type: :request do
  describe 'POST #create' do
    include ApiDoc::Account::Sessions::Create

    let(:params) { { email: email, password: password } }
    let(:email) { FFaker::Internet.email }
    let(:password) { 'MegaPassword0' }

    before do
      create(:user, email: email, password: password)
      post account_session_path, params: params
    end

    describe 'Success' do
      it 'creates a session' do
        expect(response).to be_created
      end

      it 'matches json schema' do
        expect(response.body).to match_json_schema('account/sessions/create')
      end
    end

    describe 'Failure' do
      context 'with wrong email' do
        let(:params) { { email: 'wrong@email', password: password } }

        it 'has errors' do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('errors')
        end
      end

      context 'with wrong password' do
        let(:params) { { email: email, password: 'wrong_password' } }

        it 'has errors' do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('errors')
        end
      end
    end
  end
end
