class CoursesController < BaseController
    before_action :logged_in_user
    def index
        if logged_in_user.academic.present?
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
        if logged_in_user.academic.present?
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
        if logged_in_user.admin? || logged_in_user.role == "admin" || logged_in_user.role == "teacher"
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
    end

    def elastic_search
        if logged_in_user.academic.present?
            user_modul = params[:course]
            user_category_name = params[:category]
            user_subcategory_name = params[:subcategory]
            matching_courses = Course.joins(:category, :subcategory)
                         .where("courses.modul LIKE ?", "%#{user_modul}%")
                         .where(categories: { name: user_category_name })
                         .where(subcategories: { name: user_subcategory_name })

        
            if matching_courses.any?
                render json: { 
                    message: "Courses Found Based on your Search",
                    courses: matching_courses.as_json(only: [:id,:modul], include: { chapters: { only: [:id,:chap] } }) 
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
        if logged_in_user.academic.present?
            if logged_in_user.role == "admin" || logged_in_user.role == "teacher" || logged_in_user.admin?
                course = set_course
                if course.destroy
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
        params.require(:course).permit(:modul,:category_id, :subcategory_id)
    end
end
