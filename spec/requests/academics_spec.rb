require 'rails_helper'
require 'jwt'

RSpec.describe AcademicsController, type: :controller do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods
  let!(:user) { FactoryBot.create(:user) }
  let!(:admin_user) { create(:user, role: "admin") }
  let!(:academic_admin){ create(:academic, user: admin_user)}
  let(:intrest) { FactoryBot.create(:intrest) }
  let(:qualification) { FactoryBot.create(:qualification) }
  describe "GET /index" do
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
    end
    it 'returns all the academic details present if present' do

      get :index

      expect(response).to have_http_status(200)
    end

    it 'if there is no academics' do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
      get :index
    end
    let(:academic_params) { attributes_for(:academic, user: user, intrest: intrest, qualification: qualification) }

    context 'when valid parameters are provided' do
      it 'creates a new academic' do
        post :create, params: { academic: academic_params }
        expect(response).to have_http_status(422)
      end
    end

    context 'when invalid parameters are provided' do
      let(:invalid_params) { academic_params.except(:college_name) }
      it 'returns an error' do
        post :create, params: { academic: invalid_params }

        expect(response).to have_http_status(422)
      end
    end
  end
  def generate_token(user_id)
    expiration_time = 24.hours.from_now.to_i

    payload = { sub: user_id, exp: expiration_time }

    secret_key = Rails.application.credentials.fetch(:secret_key_base)
    token = JWT.encode(payload, secret_key)

    token
  end
end
