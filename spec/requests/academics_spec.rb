require 'rails_helper'

RSpec.describe "Academics", type: :request do
  include Devise::Test::IntegrationHelpers
  let(:intrest) { FactoryBot.create(:intrest) }
  let(:qualification) { FactoryBot.create(:qualification) }
  let(:user) { FactoryBot.create(:user) }
  describe "GET /index" do
    it 'returns all the academic details present if present' do

      get '/academics'

      expect(response).to have_http_status(404)
    end

    it 'if there is no academics' do
      get '/academics'

      expect(response).to have_http_status(404)
    end
  end

  describe 'POST #create' do
    let(:academic_params) { attributes_for(:academic, user_id: user.id, intrest_id: intrest.id, qualification_id: qualification.id) }

    context 'when valid parameters are provided' do
      it 'creates a new academic' do
        post '/academic', params: { academic: academic_params }
        expect(response).to have_http_status(200)
      end
    end

    context 'when invalid parameters are provided' do
      let(:invalid_params) { academic_params.except(:college_name) }
      it 'returns an error' do
        post '/academic', params: { academic: invalid_params }

        expect(response).to have_http_status(422)
      end
    end
  end
end
