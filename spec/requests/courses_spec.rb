require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods
  let!(:admin_user) { create(:user, role: "admin") }
  let!(:academic_admin){ create(:academic, user: admin_user)}
  let!(:user) { create(:user, role: "student") }
  let!(:academic) { create(:academic, user: user)}
  let!(:course){ create(:course)}
  let!(:category) { create(:category)} 
  let!(:subcategory) { create(:subcategory, category_id: category.id)} 

  describe 'GET elastic_search' do
    context 'when user is logged in with academic record' do
      before do
        sign_in user, scope: :user
        request.headers['token'] = generate_token(user.id)
      end

      context 'when courses are found based on the search' do
        before do
          sign_in user, scope: :user
          request.headers['token'] = generate_token(user.id)
        end
        let!(:matching_course) { create(:course, modul: 'Matching Module', category_id: 1) }

        it 'returns a successful response with matching courses' do
          get :elastic_search, params: { course: 'Matching Module', category: 1 }

          expect(response).to have_http_status(200)
        end
      end
    end
  end


  describe "GET #index" do
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
      get :index
    end
    it "returns  course" do
      expect(response).to have_http_status(200)
      expect(response.parsed_body['message']).to eq("Courses Found" )
    end

    it "returns not found when no course are available" do
      get :index
      expect(response).to have_http_status(200)
      expect(response.parsed_body['message']).to eq("Courses Found")
    end
  end

  describe "GET #show" do
    let!(:course) { create(:course) }
    before do
      sign_in user, scope: :user
      request.headers['token'] = generate_token(user.id)
      get :show, params: { id: course.id }
    end

    it "returns the requested course" do
      expect(response).to have_http_status(200)
      expect(response.parsed_body['message']).to eq("Course Found")
    end

    it "returns not found when course is not available" do
      expect(response).to have_http_status(200)
      expect(response.parsed_body['message']).to eq("Course Found")
    end
  end

  describe "POST #create" do
    context "when user is authenticated" do
      before do
        sign_in admin_user, scope: :admin_user
        request.headers['token'] = generate_token(admin_user.id)
      end

      it "creates a new course" do
        expect {
          post :create, params: { course: { name: "John", category_id: category.id, subcategory_id: subcategory.id} }
        }.to change(Course, :count).by(0)
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:course) { create(:course) }

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
    it "deletes the course" do
      allow_any_instance_of(Course).to receive(:delete).and_return(false)
      delete :destroy, params: { id: course.id }
      expect(response).to have_http_status(200)
      expect(response.parsed_body['message']).to eq("Course Deleted Successfully")
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

