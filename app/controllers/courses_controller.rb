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

    def elastic_search
        if current_user.academic.present?
            search = params[:course]
            courses = Course.where("modul like ?","%#{search}%")
            if courses
                render json: {
                    message: "Course Found In #{params[:course]} Successfully",
                    course: courses.as_json(only: [:id,:modul], include: { chapters: { only: [:id,:chap] } })
                }, status: :ok
            else
                render json: {
                    message: "Course Not Found In #{params[:course]} Successfully",
                    error: courses.errors.full_messages
                }, status: 422
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
end
