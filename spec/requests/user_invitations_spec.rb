# frozen_string_literal: true

RSpec.describe 'UserInvitations', :dox, type: :request do
  include ApiDoc::UserInvitations::Api

  describe 'POST #create' do
    include ApiDoc::UserInvitations::Create

    let(:current_user) { create(:user, is_admin: is_admin) }
    let(:is_admin) { true }
    let(:params) { { email: FFaker::Internet.unique.email } }
    let(:headers) { { Authorization: { user_id: current_user.id }.to_json } }

    before do
      post user_invitations_path, params: params, headers: headers
    end

    describe 'Success' do
      it 'creates UserInvitation', :dox do
        expect(response).to be_created
        expect(response.body).to be_empty
      end
    end

    describe 'Failure' do
      context 'when authorization headers is not valid' do
        let(:headers) { {} }

        it 'renders errors' do
          expect(response).to be_unauthorized
          expect(response).to match_json_schema('errors')
        end
      end

      context 'when current_user is not an admin' do
        let(:is_admin) { false }

        it 'returns forbidden status' do
          expect(response).to be_forbidden
          expect(response.body).to be_empty
        end
      end

      context 'with invalid params' do
        let(:params) { { user_invitation: { email: 'invalid' } } }

        it 'renders errors' do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('errors')
        end
      end
    end
  end
end
