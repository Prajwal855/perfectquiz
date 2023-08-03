require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods
  describe "GET #index" do
    it "returns no users" do
      get :index
      expect(response).to have_http_status(:not_found)
    end

    it "returns not found when no users are available" do
      User.destroy_all
      get :index
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["users"]).to be_empty
    end
  end

  describe "GET #show" do
    let(:user) { create(:user) }

    it "returns the requested user" do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body["user"]["id"]).to eq(user.id)
    end

    it "returns not found when user is not available" do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["user"]).to be_empty
    end
  end

  describe "POST #create" do
    it "creates a new user" do
      expect {
        post :create, params: { user: { name: "John Doe", email: "john@example.com", password: "password", role: "student" } }
      }.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
      response_body = JSON.parse(response.body)
      expect(response_body["user"]["name"]).to eq("John Doe")
    end
  end

  describe "PATCH #update" do
    let(:user) { create(:user) }

    it "updates the user" do
      patch :update, params: { id: user.id, user: { name: "Updated Name" } }
      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body["user"]["name"]).to eq("Updated Name")
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { create(:user) }

    it "deletes the user" do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body["user"]["id"]).to eq(user.id)
    end
  end
end


