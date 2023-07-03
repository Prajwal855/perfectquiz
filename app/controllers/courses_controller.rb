class CoursesController < ApplicationController
    before_action :current_user
    def index
        if current_user.academic.present?
            courses = Course.all
            if courses.empty?
                render json: {
                    message: "Courses Not Found",
                    courses: []
                }, status: :not_found
            else
                render json: {
                    message: "Courses Found",
                    courses: courses.as_json(only: [:id,:modul], include: { chapters: { only: [:id,:chap] } })
                }, status: :ok
            end
        else
            render json: { message: "Dude Complete the Academic Form First"
                }, status: 401
        end
    end

    def show
        if current_user.academic.present?
            course = set_course
            if course
                render json: {message: "Course Found",
                course: course.as_json(only: [:modul])
            }, status: :ok
            else
                render json: {
                    message: "Course Not Found",
                    course: []
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
                course = Course.create(course_params)
                if course.save
                    render json: {
                        message: "Course Created Successfully",
                        course: course
                    }, status: :created
                else
                    render json: {
                        message: "Course cannot be Created",
                        error: course.errors.full_messages
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
                course = set_course
                if course.update(course_params)
                    render json: {
                        message: "Course Updated Successfully",
                        course: course.as_json(only: [:modul])
                    }, status: :ok
                else
                    render json: {
                        message: "Course Cannot be Updated",
                        error: course.errors.full_messages
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
                course = set_course
                if course.delete
                    render json: {
                        message: "Course Deleted Successfully",
                        course: course.as_json(only: [:modul])
                    }, status: :ok
                else
                    render json: {
                        message: "Course Cannot Be Deleted",
                        error: course.errors.full_messages
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
    def set_course
        course = Course.find_by(id: params[:id])
        if course
            return course
        end
    end
    def course_params
        params.require(:course).permit(:modul)
    end

    def current_user
        jwt_payload = JWT.decode(request.headers['token'], Rails.application.credentials.fetch(:secret_key_base)).first
        current_user = User.find(jwt_payload['sub'])
        if current_user
            return current_user
        end
    end
end