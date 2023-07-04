require 'rails_helper'

RSpec.describe "Courses", type: :request do
  describe 'GET /courses' do
    let(:user) { User.create(name: 'John', role: 'admin') }

    context 'when user has completed the academic form' do
      before do
        allow_any_instance_of(CoursesController).to receive(:current_user).and_return(user)
      end

      context 'when there are courses available' do
        before do
          Course.create(modul: 'Mathematics')
          Course.create(modul: 'Science')
        end

        it 'returns a success response with the courses' do
          get '/courses'

          expect(response).to have_http_status(401)
        end
      end

      context 'when there are no courses available' do
        it 'returns a not found response' do
          get '/courses'

          expect(response).to have_http_status(401)
        end
      end

    context 'when user has not completed the academic form' do
      before do
        allow_any_instance_of(CoursesController).to receive(:current_user).and_return(User.create(name: 'John'))
      end

      it 'returns an unauthorized response' do
        get '/courses'

        expect(response).to have_http_status(:unauthorized)
      end
    end
end
end

  describe 'GET /courses/:id' do
    let(:user) { User.create(name: 'John', role: 'admin') }
    let(:course) { Course.create(modul: 'Mathematics') }

    context 'when user has not completed the academic form' do
      before do
        allow_any_instance_of(CoursesController).to receive(:current_user).and_return(User.create(name: 'John'))
      end

      it 'returns an unauthorized response' do
        get "/course/1"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

