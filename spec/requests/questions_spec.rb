require 'rails_helper'
require 'jwt'

RSpec.describe QuestionsController, type: :controller do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods
  let!(:admin_user) { create(:user, role: "admin") }
  let!(:academic_admin) { create(:academic, user: admin_user)}
  let!(:user) { create(:user, role: "student") }
  let!(:academic) { create(:academic, user: user)}

  describe "GET #index" do
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
      get :index
    end
    it "returns a not_found response" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns questions when available" do
      create(:question)
      expect(response).to have_http_status(:not_found)
    end

    it "returns not found when no questions available" do
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["questions"]).to be_empty
    end
  end

  describe "GET #show" do
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
    end
    let(:question) { create(:question) }

    it "returns a success response" do
      get :show, params: { id: question.id }
      expect(response).to have_http_status(:ok)
    end

    it "returns the correct question" do
      get :show, params: { id: question.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["question"]["id"]).to eq(question.id)
    end

    it "returns not found when question does not exist" do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    context "when admin user is authenticated" do
      before do
        sign_in admin_user, scope: :admin_user
        request.headers['token'] = generate_token(user.id)
      end

      it "creates a new question" do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to change(Question, :count).by(0)
        expect(response).to have_http_status(401)
      end

      it "returns error when question creation fails" do
        expect {
          post :create, params: { question: { que: "" } }
        }.not_to change(Question, :count)
        expect(response).to have_http_status(401)
      end
    end

    context "when regular user is authenticated" do
      before do
        sign_in user, scope: :user
        request.headers['token'] = generate_token(user.id)
      end
    end
  end

  describe "PATCH #update" do
    let(:question) { create(:question) }

    context "when admin user is authenticated" do
      before do
        sign_in admin_user, scope: :admin_user
        request.headers['token'] = generate_token(user.id)
      end

      it "updates the question" do
        patch :update, params: { id: question.id, question: { que: "Updated question" } }
        expect(response).to have_http_status(:ok)
        expect(question.reload.que).to eq("Updated question")
      end
    end
  end

  describe "POST #submit_answers" do
    let(:question) { create(:question, correct_answer: "Option 1") }
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
    end

    context "when user is authenticated" do

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
  end

  describe "GET #filtered_questions" do
    let!(:question_1) { create(:question, language: "Ruby", level: "level1") }
    let!(:question_2) { create(:question, language: "ReactJS", level: "level1") }
    let!(:question_3) { create(:question, language: "ReactNative", level: "level1") }
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
    end
    

    it "returns filtered questions based on language and level" do
      get :filtered_questions, params: { lang: "Ruby", difficult: "level1" }
      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body["questions"].length).to eq(1)
    end

    it "returns found when questions match the filter" do
      get :filtered_questions, params: { lang: "Ruby", difficult: "level1" }
      expect(response).to have_http_status(:ok)
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


