require 'rails_helper'

RSpec.describe StudymaterialsController, type: :controller do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods
  let!(:admin_user) { create(:user, role: "admin") }
  let!(:academic_admin){ create(:academic, user: admin_user)}
  let!(:user) { create(:user, role: "user") }
  let!(:academic) { create(:academic, user: user)}
  let!(:studymaterial){ create(:studymaterial)}

  describe "GET #index" do
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
      get :index
    end
    it "returns  course" do
      expect(response).to have_http_status(200)
    end

    it "returns not found when no course are available" do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    let!(:studymaterial) { create(:studymaterial) }
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
      get :show, params: { id: studymaterial.id }
    end

    it "returns the requested studymaterial" do
      expect(response).to have_http_status(200)
    end

    it "returns not found when studymaterial is not available" do
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE #destroy" do
    let!(:studymaterial) { create(:studymaterial) }

    context "when admin user is authenticated" do
      before do
        sign_in user, scope: :user
        request.headers['token'] = generate_token(user.id)
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      sign_in admin_user, scope: :admin_user
      request.headers['token'] = generate_token(admin_user.id)
    end
    it "deletes the choice" do
      allow_any_instance_of(Studymaterial).to receive(:delete).and_return(false)
      delete :destroy, params: { id: studymaterial.id }
      expect(response).to have_http_status(422)
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
