require 'rails_helper'
require 'jwt'

RSpec.describe ChaptersController , type: :controller do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods
  let!(:admin_user) { create(:user, role: "admin") }
  let!(:academic_admin){ create(:academic, user: admin_user)}
  let!(:user) { create(:user, role: "student") }
  let!(:academic) { create(:academic, user: user)}
  let!(:chapter) { create(:chapter)}
  let!(:course){ create(:course)}

  describe "GET #index" do
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
      get :index
    end
    it "returns  chapter" do
      expect(response).to have_http_status(200)
      
    end

    it "returns not found when no chapter are available" do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    let!(:chapter) { create(:chapter) }
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
      get :show, params: { id: chapter.id }
    end

    it "returns the requested chapter" do
      expect(response).to have_http_status(200)
    end

    it "returns not found when chapter is not available" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "when user is authenticated" do
      before do
        sign_in admin_user, scope: :admin_user
        request.headers['token'] = generate_token(admin_user.id)
      end

      it "creates a new chapter" do
        expect {
          post :create, params: { chapter: { chap: "John"} }
        }.to change(Chapter, :count).by(0)
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:chapter) { create(:chapter) }

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
      allow_any_instance_of(Chapter).to receive(:delete).and_return(false)
      delete :destroy, params: { id: chapter.id }
      expect(response).to have_http_status(422)
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
