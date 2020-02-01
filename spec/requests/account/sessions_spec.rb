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

  describe 'DELETE #destroy' do
    include ApiDoc::Account::Sessions::Destroy

    let(:user) { create(:user) }

    describe 'Success' do
      let(:headers) { authorization_header(user) }
      let(:jwt_session) { instance_double(JWTSessions::Session) }

      it 'returns no_content' do
        delete account_session_path, headers: headers
        expect(response).to be_no_content
        expect(response.body).to be_empty
      end

      describe 'destroys a session' do
        before do
          allow(JWTSessions::Session).to receive(:new)
            .with(payload: { user_id: user.id }, refresh_by_access_allowed: true)
            .and_call_original
          allow(JWTSessions::Session).to receive(:new)
            .with(no_args)
            .and_return(jwt_session)
          allow(jwt_session).to receive(:session_exists?).and_return(true)
          allow(jwt_session).to receive(:flush_by_uid)
        end

        it 'destroys a session' do
          delete account_session_path, headers: headers
          expect(jwt_session).to have_received(:flush_by_uid)
        end
      end
    end

    describe 'Failure' do
      before { delete account_session_path, headers: headers }

      context 'when authorization header is not valid' do
        let(:headers) { nil }

        it 'has errors' do
          expect(response).to be_unauthorized
          expect(response).to match_json_schema('errors')
        end
      end
    end
  end
end
