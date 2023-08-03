class CoursesController < BaseController
    before_action :logged_in_user, only: [:index, :show]
    before_action :check_admin_user, only: [:create, :destroy]
    
    def index
        courses = Course.all
        if courses.empty?
            render json: {
                message: "Courses Not Found",
                courses: []
            }, status: :not_found
        else
            render json: {
                message: "Courses Found",
                courses: courses
            }, status: :ok
        end
    end

    def show
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
    end

    def create
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
    end

    def elastic_search
        user_modul = params[:course]
        category_id = params[:category]
        subcategory_id = params[:subcategory]
        from_date = params[:from_date]
        to_date = params[:to_date]
        matching_courses = Course.all
        if user_modul.present? && category_id.present? && subcategory_id.present? && from_date.present? &&to_date.present?
            category_id = category_id.to_i
            subcategory_id = subcategory_id.to_i
            matching_courses = matching_courses.where("modul LIKE ? AND category_id = ? AND subcategory_id = ? AND created_at <= ?", user_modul, category_id, subcategory_id, from_date.to_date.beginning_of_day..to_date.to_date.end_of_day )
        elsif user_modul.present? && category_id.present? && subcategory_id.present?
            category_id = category_id.to_i
            subcategory_id = subcategory_id.to_i
            matching_courses = matching_courses.where("modul LIKE ? AND category_id = ? AND subcategory_id = ?", "%#{user_modul}%", category_id, subcategory_id)
        elsif user_modul.present? && category_id.present? && from_date.present?
            category_id = category_id.to_i
            matching_courses = matching_courses.where("modul LIKE ? AND category_id = ? AND created_at = ?",user_modul, category_id, from_date)
        elsif user_modul.present? && subcategory_id.present? && from_date.present?
            subcategory_id = subcategory_id.to_i
            matching_courses = matching_courses.where("modul LIKE ? AND subcategory_id = ? AND created_at = ?", user_modul, subcategory_id, from_date)
        elsif user_modul.present? && category_id.present?
            category_id = category_id.to_i
            matching_courses = matching_courses.where("modul LIKE ? AND category_id = ?", "%#{user_modul}%", category_id)
        elsif user_modul.present? && subcategory_id.present?
            subcategory_id = subcategory_id.to_i
            matching_courses = matching_courses.where("modul LIKE ? AND subcategory_id = ?", "%#{user_modul}%", subcategory_id)
        elsif category_id.present? && subcategory_id.present?
            category_id = category_id.to_i
            subcategory_id = subcategory_id.to_i
            matching_courses = matching_courses.where("category_id = ? AND subcategory_id = ?", category_id, subcategory_id)
        elsif user_modul.present?
            matching_courses = matching_courses.where("modul LIKE ?", "%#{user_modul}%")
        elsif category_id.present? && from_date.present?
            category_id = category_id.to_i
            matching_courses = matching_courses.where("category_id = ? AND created_at >= ?", category_id, from_date.to_date.beginning_of_day)
        elsif subcategory_id.present? && from_date.present?
            subcategory_id = subcategory_id.to_i
            matching_courses = matching_courses.where("subcategory_id = ? AND created_at >= ?", subcategory_id, from_date.to_date.beginning_of_day)
        elsif category_id.present?
            category_id = category_id.to_i
            matching_courses = matching_courses.where(category_id: category_id)
        elsif subcategory_id.present?
            subcategory_id = subcategory_id.to_i
            matching_courses = matching_courses.where(subcategory_id: subcategory_id)
        elsif from_date.present? && to_date.present?
            matching_courses = matching_courses.where(created_at: from_date.to_date.beginning_of_day..to_date.to_date.end_of_day)
        elsif from_date.present?
            matching_courses = matching_courses.where("created_at >= ?", from_date.to_date.beginning_of_day)
        elsif to_date.present?
            matching_courses = matching_courses.where("created_at <= ?", to_date.to_date.end_of_day)
        end
    
        if matching_courses.any?
        render json: { 
            message: "Courses Found Based on your Search",
            meta: {
                courses: matching_courses 
            }
        }, status: :ok
        else
        render json: {
            message: "No Courses Found",
            meta:{ 
                message:"Course Not Found In #{params[:course]} Successfully"
            }
        }, status: 404
        end
    end

    def destroy
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
    end
    private
    def set_course
        course = Course.find(params[:id])
        if course
            return course
        end
    end

    def check_admin_user
        if logged_in_user.admin? || logged_in_user.role == "admin" || logged_in_user.role == "teacher"
            return logged_in_user
        else
            render json: { message: "Dude You Don't have permission"
             }, status: 401
        end
    end

    def course_params
        params.require(:course).permit(:modul,:category_id, :subcategory_id)
    end
end
