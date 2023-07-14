class StudymaterialsController < BaseController
    before_action :current_user
    def index
        if current_user.academic.present?
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
        else
            render json: { message: "Dude Complete the Academic Form First"
                }, status: 401
        end
    end

    def show
        if current_user.academic.present?
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
        else
            render json: { message: "Dude Complete the Academic Form First"
                }, status: 401
        end
    end

    def create
        if current_user.admin? || current_user.role == "admin" || current_user.role == "teacher"
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
        if current_user.admin? || current_user.role == "admin" || current_user.role == "teacher"
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
