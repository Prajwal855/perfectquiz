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
        page = params[:page] || 1
        per_page = params[:per_page] || 10
    
        if params[:modul_cont]
            if Course.ransack(modul_cont: params[:modul_cont]).result.count > 1
                @courses = Course.ransack(modul_cont: params[:modul_cont]).result
            else
                render json:{
                    message: "Course does not exist with title #{params[:modul_cont]} "
                }, status: 404
                return
            end
        else
            @courses = Course.all
        end
    
        if params[:category_id].present?
            if @courses.exists?(category_id: params[:category_id])
                @courses = @courses.where(category_id: params[:category_id]) 
            else 
                render json:{
                    message: "Course does not exist with category id #{params[:category_id]} "
                }, status: 404
                return
            end 
        end
        
        if params[:sub_category_id].present? && 
            if @courses.exists?(subcategory_id: params[:sub_category_id])
                @courses = @courses.where(subcategory_id: params[:sub_category_id]) 
            else
                render json:{
                    message: "Course does not exist with sub-category id #{params[:sub_category_id]} "
                }, status: 404
                return
            end
        end
    
        @courses = @courses.page(page).per(per_page)
    
        render json: {
        type: "course",
        current_page: page,
        total_pages: @courses.page(page).per(per_page).total_pages,
        total_records: @courses.count,
        courses: ActiveModelSerializers::SerializableResource.new(@courses),
        message: "Courses Listed successfully"
        }, status: 200
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
