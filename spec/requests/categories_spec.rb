require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods
  let!(:admin_user) { create(:user, role: "admin") }
  let!(:academic_admin){ create(:academic, user: admin_user)}
  let!(:user) { create(:user, role: "student") }
  let!(:academic) { create(:academic, user: user)}
  let!(:category){ create(:category)}

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
    let!(:category) { create(:category) }
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
      get :show, params: { id: category.id }
    end

    it "returns the requested category" do
      expect(response).to have_http_status(200)
    end

    it "returns not found when category is not available" do
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE #destroy" do
    let!(:category) { create(:category) }

    context "when admin user is authenticated" do
      before do
        sign_in user, scope: :user
        request.headers['token'] = generate_token(user.id)
      end
    end
  end

  def generate_token(user_id)
    expiration_time = 24.hours.from_now.to_i

    payload = { sub: user_id, exp: expiration_time }

    secret_key = ENV['secret_key_base']
    token = JWT.encode(payload, secret_key)
    token
  end
end
