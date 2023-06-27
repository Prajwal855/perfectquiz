require 'rails_helper'

RSpec.describe ChoicesController, type: :controller do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods
  let(:question) { create(:question) }
  let(:admin_user) { create(:user, role: "admin") }
  let(:user) { create(:user, role: "user") }
  let(:choices){ create(:choice)}

  describe "GET #index" do
    it "returns no choices" do
      sign_in user
      get :index
      expect(response).to have_http_status(:not_found)
    end

    it "returns not found when no choices are available" do
      sign_in user
      Choice.destroy_all
      get :index
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #show" do
    let(:choice) { create(:choice) }

    it "returns the requested choice" do
      sign_in user
      get :show, params: { id: choice.id }
      expect(response).to have_http_status(:ok)
    end

    it "returns not found when choice is not available" do
      sign_in user
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    context "when user is authenticated" do
      before { sign_in admin_user }

      it "creates a new choice" do
        expect {
          post :create, params: { choice: { option: "Option 1", question_id: create(:question).id } }
        }.to change(Choice, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "when no user is authenticated" do
      it "returns unauthorized status" do
        post :create, params: { choice: { option: "Option 1", question_id: create(:question).id } }
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "PATCH #update" do
    let(:choice) { create(:choice) }

    context "when admin user is authenticated" do
      before { sign_in admin_user }

      it "updates the choice" do
        patch :update, params: { id: choice.id, choice: { option: "Updated Option" } }
        expect(response).to have_http_status(:ok)
      end
    end

    context "when no user is authenticated" do
      it "returns unauthorized status" do
        patch :update, params: { id: choice.id, choice: { option: "Updated Option" } }
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:choice) { create(:choice) }

    context "when admin user is authenticated" do

      it "returns error when choice deletion fails" do
        sign_in user
        allow_any_instance_of(Choice).to receive(:delete).and_return(false)
        delete :destroy, params: { id: choice.id }
        expect(response).to have_http_status(422)
        
      end
    end

    context "when no user is authenticated" do
      it "returns unauthorized status" do
        delete :destroy, params: { id: choice.id }
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the choice" do
      sign_in user
      allow_any_instance_of(Choice).to receive(:delete).and_return(false)
      delete :destroy, params: { id: choices.id }
      expect(response).to have_http_status(422)
    end
  end
end



