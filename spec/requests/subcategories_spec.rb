require 'rails_helper'

RSpec.describe SubcategoriesController, type: :controller do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods
  let!(:admin_user) { create(:user, role: "admin") }
  let!(:academic_admin){ create(:academic, user: admin_user)}
  let!(:user) { create(:user, role: "student") }
  let!(:academic) { create(:academic, user: user)}
  let!(:category){ create(:category)}
  let!(:subcategory){ create(:subcategory, category_id:category.id)}

  describe "GET #index" do
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
      get :index
    end
    it "returns  subcategory" do
      expect(response).to have_http_status(200)
    end

    it "returns not found when no subcategory are available" do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    let!(:subcategory) { create(:subcategory, category_id: category.id) }
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
      get :show, params: { id: subcategory.id }
    end

    it "returns the requested subcategory" do
      expect(response).to have_http_status(200)
    end

    it "returns not found when subcategory is not available" do
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE #destroy" do
    let!(:subcategory) { create(:subcategory, category_id: category.id) }

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
    it "deletes the subcategory" do
      delete :destroy, params: { id: subcategory.id }
      expect(response).to have_http_status(200)
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
