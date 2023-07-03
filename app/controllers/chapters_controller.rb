class ChaptersController < ApplicationController
    before_action :current_user
    def index
        if current_user.academic.present?
            chapters = Chapter.all
            if chapters.empty?
                render json: {
                    message: "Chapters Not Found",
                    chapters: []
                }, status: :not_found
            else
                render json: {
                    message: "Chapters Found",
                    chapters: chapters.as_json(only: [:chap, :course_id])
                }, status: :ok
            end
        else
            render json: { message: "Dude Complete the Academic Form First"
                }, status: 401
        end
    end

    def show
        if current_user.academic.present?
            chapter = set_chapter
            if chapter
                render json: {message: "Chapter Found",
                chapter:chapters.as_json(only: [:chap, :course_id])
            }, status: :ok
            else
                render json: {
                    message: "Chapter Not Found",
                    chapter: []
                }, status: :not_found
            end
        else
            render json: { message: "Dude Complete the Academic Form First"
                }, status: 401
        end
    end

    def create
        if current_user.academic.present?
            if current_user.role == "admin" || current_user.role == "teacher"
                chapter = Chapter.create(chapter_params)
                if chapter.save
                    render json: {
                        message: "Chapter Created Successfully",
                        chapter: chapter.as_json(only: [:chap, :course_id])
                    }, status: :created
                else
                    render json: {
                        message: "Chapter cannot be Created",
                        error: chapter.errors.full_messages
                    }, status: 422
                end
            else
                render json: { message: "Dude You Don't have permission"
                }, status: 401
            end
        else
            render json: { message: "Dude Complete the Academic Form First"
                }, status: 401
        end
    end
    def update
        if current_user.academic.present?
            if current_user.role == "admin" || current_user.role == "teacher"
                chapter = set_chapter
                if chapter.update(chapter_params)
                    render json: {
                        message: "Chapter Updated Successfully",
                        chapter: chapter.as_json(only: [:chap, :course_id])
                    }, status: :ok
                else
                    render json: {
                        message: "Chapter Cannot be Updated",
                        error: chapter.errors.full_messages
                    }, status: 422
                end
            else
                render json: { message: "Dude You Don't have permission"
                }, status: 401
            end
        else
            render json: { message: "Dude Complete the Academic Form First"
                }, status: 401
        end
    end
    def destroy
        if current_user.academic.present?
            if current_user.role == "admin" || current_user.role == "teacher"
                chapter = set_chapter
                if chapter.delete
                    render json: {
                        message: "Chapter Deleted Successfully",
                        chapter: chapter.as_json(only: [:chap, :course_id])
                    }, status: :ok
                else
                    render json: {
                        message: "Chapter Cannot Be Deleted",
                        error: chapter.errors.full_messages
                    }, status: 422
                end
            else
                render json: { message: "Dude You Don't have permission"
                }, status: 401
            end
        else
            render json: { message: "Dude Complete the Academic Form First"
                }, status: 401
        end
    end
    private
    def set_chapter
        chapter = Chapter.find_by(id: params[:id])
        if chapter
            return chapter
        end
    end
    def chapter_params
        params.require(:chapter).permit(:chap,:course_id)
    end
    def current_user
        jwt_payload = JWT.decode(request.headers['token'], Rails.application.credentials.fetch(:secret_key_base)).first
        current_user = User.find(jwt_payload['sub'])
        if current_user
            return current_user
        end
    end
end
