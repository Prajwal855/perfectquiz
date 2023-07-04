
require 'rails_helper'

RSpec.describe "Chapters", type: :request do
  let(:user) { User.create(name: 'John', role: 'admin') }
  describe 'GET /chapters' do
    context 'when user has completed the academic form' do
      before do
        Chapter.create(chap: 'Chapter 1', course_id: 1)
        Chapter.create(chap: 'Chapter 2', course_id: 1)
        get '/chapters'
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the chapters' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Chapters Found')
        expect(json_response['chapters'].size).to eq(2)
      end
    end

    context 'when user has not completed the academic form' do
      before do
        user.academic.present?
        get '/chapters'
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Dude Complete the Academic Form First')
      end
    end
  end

  describe 'GET /chapters/:id' do
    let(:chapter) { Chapter.create(chap: 'Chapter 1', course_id: 1) }

    context 'when user has completed the academic form' do
      before do
        get "/chapter/1"
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the chapter' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Chapter Found')
        expect(json_response['chapter']['chap']).to eq(chapter.chap)
      end
    end

    context 'when user has not completed the academic form' do
      before do
        user.update(academic: false)
        get "/chapter/1"
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Dude Complete the Academic Form First')
      end
    end

    context 'when chapter does not exist' do
      before do
        get '/chapter/999'
      end

      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Chapter Not Found')
      end
    end
  end

  describe 'POST /chapters' do
    let(:valid_params) { { chapter: { chap: 'Chapter 1', course_id: 1 } } }

    context 'when user has completed the academic form' do
      context 'when user is admin or teacher' do
        before do
          post '/chapter', params: valid_params
        end

        it 'returns a success response' do
          expect(response).to have_http_status(:created)
        end

        it 'creates a new chapter' do
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq('Chapter Created Successfully')
          expect(json_response['chapter']['chap']).to eq(valid_params[:chapter][:chap])
        end
      end

      context 'when user is not admin or teacher' do
        before do
          user.update(role: 'admin')
          post '/chapter', params: valid_params, headers: headers
        end

        it 'returns an unauthorized response' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns an error message' do
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq("Dude You Don't have permission")
        end
      end
    end

    context 'when user has not completed the academic form' do
      before do
        post '/chapter', params: valid_params
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Dude Complete the Academic Form First')
      end
    end
  end

  describe 'PUT /chapters/:id' do
    let(:chapter) { Chapter.create(chap: 'Chapter 1', course_id: 1) }
    let(:valid_params) { { chapter: { chap: 'Updated Chapter', course_id: 1 } } }

    context 'when user has completed the academic form' do
      context 'when user is admin or teacher' do
        before do
          put "/chapter/1", params: valid_params
        end

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end

        it 'updates the chapter' do
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq('Chapter Updated Successfully')
          expect(json_response['chapter']['chap']).to eq(valid_params[:chapter][:chap])
        end
      end

      context 'when user is not admin or teacher' do
        before do
          user.update(role: 'student')
          put "/chapter/1", params: valid_params
        end

        it 'returns an unauthorized response' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns an error message' do
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq("Dude You Don't have permission")
        end
      end
    end

    context 'when user has not completed the academic form' do
      before do
        put "/chapter/1", params: valid_params
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Dude Complete the Academic Form First')
      end
    end
  end

  describe 'DELETE /chapters/:id' do
    let(:chapter) { Chapter.create(chap: 'Chapter 1', course_id: 1) }

    context 'when user has completed the academic form' do
      context 'when user is admin or teacher' do
        before do
          delete "/chapter/1"
        end

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end

        it 'deletes the chapter' do
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq('Chapter Deleted Successfully')
          expect(json_response['chapter']['chap']).to eq(chapter.chap)
        end
      end

      context 'when user is not admin or teacher' do
        before do
          user.update(role: 'student')
          delete "/chapter/#{chapter.id}", headers: headers
        end

        it 'returns an unauthorized response' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns an error message' do
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq("Dude You Don't have permission")
        end
      end
    end

    context 'when user has not completed the academic form' do
      before do
        user.update(academic: false)
        delete "/chapter/1"
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Dude Complete the Academic Form First')
      end
    end
  end
end
