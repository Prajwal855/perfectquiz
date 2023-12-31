class QualificationsController < BaseController
    before_action :logged_in_user, only: [:index, :show]
    before_action :check_admin_user, only: [:create, :destroy]
    def index 
        qualifications = Qualification.all
        if  qualifications.empty?
            render json: {
                message:    "Qualifications Not Found",
                qualifications: []
            }, status: :not_found
        else
            render json: {
                message:    "Qualifications Found",
                qualifications: qualifications.as_json(only: [:id, :name])
            }, status: :ok
        end
    end

    def show
        qualification = set_qualification
        if qualification
            render json: {
                message: "Qualification Found",
                qualification: qualification.as_json(only: [:id, :name])
            }, status: :ok
        else
            render json: {
                message: "Qualification Not Found",
                qualification: []
            }, status: :not_found
        end
    end

    def create
        qualification = Qualification.create(qualification_params)
        if qualification.save
            render json: {
                message: "Qualification Created successfully",
                qualification: qualification.as_json(only: [:id, :name])
            }, status: :created
        else
            render json: {
                message: "Qualification Unable to Create",
                error: qualification.errors.full_messages
            }, status: 422
        end
    end


    def destroy
        qualification = set_qualification
        if qualification.delete
            render json: {
                message: "Qualification Deleted Successfully",
                qualification: qualification.as_json(only: [:id, :name])
            }, status: :ok
        else
            render json: {
                message: "Qualification unable to Delete",
                error: qualification.errors.full_messages
            }, status: 422
        end
    end

    private
    def qualification_params
        params.require(:qualification).permit(:name)
    end

    def check_admin_user
        if logged_in_user.admin? || logged_in_user.role == "admin"
            return logged_in_user
        else
            render json: { message: "Dude You Don't have permission"
             }, status: 401
        end
    end

    def set_qualification
        qualification = Qualification.find_by(id: params[:id])
        if qualification
            return qualification
        end
    end
end
