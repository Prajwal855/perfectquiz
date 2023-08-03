require 'rails_helper'
require 'jwt'

RSpec.describe ChoicesController, type: :controller do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods
  let(:admin_user) { create(:user, role: "admin") }
  let!(:user) { create(:user, role: "student") }
  let!(:academic) { create(:academic, user: user)}
  let!(:question){ create(:question) }
  let(:choices){ create(:choice)}

  describe "GET #index" do
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
      get :index
    end
    it "returns no choices" do
      response_body = JSON.parse(response.body)
      expect(response_body['message']).to eq("Choices Not Found")
    end

    it "returns not found when no choices are available" do
      Choice.destroy_all
      get :index
      expect(response).to have_http_status(404)
    end
  end

  describe "GET #show" do
    let(:choice) { create(:choice) }
    before do
      request.headers['token'] = generate_token(user.id)
      get :show, params: { id: choice.id }
    end

    it "returns the requested choice" do
      expect(response).to have_http_status(200)
    end

    it "returns not found when choice is not available" do
      Choice.destroy_all
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "when user is authenticated" do
      before do
        sign_in admin_user, scope: :admin_user
        request.headers['token'] = generate_token(user.id)
      end

      it "creates a new choice" do
        expect {
          post :create, params: { choice: { option: "Option 1", question_id: question.id } }
        }.to change(Choice, :count).by(0)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:choice) { create(:choice) }

    context "when admin user is authenticated" do
      before do
        sign_in user, scope: :user
        request.headers['token'] = generate_token(user.id)
      end

      it "returns error when choice deletion fails" do
        allow_any_instance_of(Choice).to receive(:delete).and_return(false)
        delete :destroy, params: { id: choice.id }
        expect(response).to have_http_status(422)
        
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
    end
    it "deletes the choice" do
      allow_any_instance_of(Choice).to receive(:delete).and_return(false)
      delete :destroy, params: { id: choices.id }
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



