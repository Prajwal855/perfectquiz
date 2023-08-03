class StudymaterialsController < BaseController
    before_action :logged_in_user
    def index
        studymaterials = Studymaterial.all
        if studymaterials.empty?
            render json: {
                message: "Studymaterials Not Found",
                studymaterials: []
            }, status: :not_found
        else
            render json: {
                message: "Studymaterials Found",
                studymaterials: StudymaterialSerializer.new(studymaterials)
            }, status: :ok
        end
    end

    def show
        studymaterial = set_studymaterial
        if studymaterial
            render json: {message: "Studymaterial Found",
            studymaterial:StudymaterialSerializer.new(studymaterial)
        }, status: :ok
        else
            render json: {
                message: "Studymaterial Not Found",
                studymaterial: []
            }, status: :not_found
        end
    end

    def create
        if logged_in_user.admin? || logged_in_user.role == "admin" || logged_in_user.role == "teacher"
            studymaterial = Studymaterial.create(studymaterial_params)
            if studymaterial.save
                render json: {
                    message: "Studymaterial Created Successfully",
                    studymaterial: StudymaterialSerializer.new(studymaterial)
                }, status: :created
            else
                render json: {
                    message: "Studymaterial cannot be Created",
                    error: studymaterial.errors.full_messages
                }, status: 422
            end
        else
            render json: { message: "Dude You Don't have permission"
            }, status: 401
        end
    end

    def destroy
        if logged_in_user.admin? || logged_in_user.role == "admin" || logged_in_user.role == "teacher"
            studymaterial = set_studymaterial
            if studymaterial.delete
                render json: {
                    message: "Studymaterial Deleted Successfully",
                    Studymaterial: StudymaterialSerializer.new(studymaterial)
                }, status: :ok
            else
                render json: {
                    message: "Studymaterial Cannot Be Deleted",
                    error: studymaterial.errors.full_messages
                }, status: 422
            end
        else
            render json: { message: "Dude You Don't have permission"
            }, status: 401
        end
    end
    private
    
    def set_studymaterial
        studymaterial = Studymaterial.find_by(id: params[:id])
        if studymaterial
            return studymaterial
        end
    end

    def studymaterial_params
        params.permit(:textbook,:chapter_id,:video, :softcopy)
    end
end
