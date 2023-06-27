require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods
  let(:admin_user) { create(:user, role: "admin") }
  let(:user) { create(:user, role: "user") }

  describe "GET #index" do
    it "returns a not_found response" do
      sign_in user
      get :index
      expect(response).to have_http_status(:not_found)
    end

    it "returns questions when available" do
      sign_in user
      create(:question)
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["questions"]).not_to be_empty
    end

    it "returns not found when no questions available" do
      sign_in user
      get :index
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["questions"]).to be_empty
    end
  end

  describe "GET #show" do
    let(:question) { create(:question) }

    it "returns a success response" do
      sign_in user
      get :show, params: { id: question.id }
      expect(response).to have_http_status(:ok)
    end

    it "returns the correct question" do
      sign_in user
      get :show, params: { id: question.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["question"]["id"]).to eq(question.id)
    end

    it "returns not found when question does not exist" do
      sign_in user
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    context "when admin user is authenticated" do
      before { sign_in admin_user }

      it "creates a new question" do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to change(Question, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it "returns error when question creation fails" do
        expect {
          post :create, params: { question: { que: "" } }
        }.not_to change(Question, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).not_to be_empty
      end
    end

    context "when regular user is authenticated" do
      before { sign_in user }

      it "returns unauthorized status" do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["message"]).to eq("Dude You Don't have permission")
      end
    end

    context "when no user is authenticated" do
      it "returns unauthorized status" do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "PATCH #update" do
    let(:question) { create(:question) }

    context "when admin user is authenticated" do
      before { sign_in admin_user }

      it "updates the question" do
        patch :update, params: { id: question.id, question: { que: "Updated question" } }
        expect(response).to have_http_status(:ok)
        expect(question.reload.que).to eq("Updated question")
      end
    end

    context "when no user is authenticated" do
      it "returns unauthorized status" do
        patch :update, params: { id: question.id, question: { que: "Updated question" } }
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "POST #submit_answers" do
    let(:question) { create(:question, correct_answer: "Option 1") }

    context "when user is authenticated" do
      before { sign_in user }

      it "returns the score and correct answers count" do
        post :submit_answers, params: {
          answers: [{ question_id: question.id, option_id: create(:choice, option: "Option 1").id }]
        }
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body["score"]).to eq(100)
        expect(response_body["correct_answers"]).to eq(1)
        expect(response_body["total_questions"]).to eq(1)
      end
    end

    context "when no user is authenticated" do
      it "returns unauthorized status" do
        post :submit_answers, params: {
          answers: [{ question_id: question.id, option_id: create(:choice, option: "Option 1").id }]
        }
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "GET #filtered_questions" do
    let!(:question_1) { create(:question, language: "Ruby", level: "level1") }
    let!(:question_2) { create(:question, language: "ReactJS", level: "level1") }
    let!(:question_3) { create(:question, language: "ReactNative", level: "level1") }
    

    it "returns filtered questions based on language and level" do
      sign_in user
      get :filtered_questions, params: { lang: "Ruby", difficult: "level1" }
      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body["questions"].length).to eq(1)
    end

    it "returns found when questions match the filter" do
      sign_in user
      get :filtered_questions, params: { lang: "Ruby", difficult: "level1" }
      expect(response).to have_http_status(:ok)
    end
  end
end


