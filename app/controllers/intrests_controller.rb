class IntrestsController < BaseController
    before_action :logged_in_user, only: [:index, :show]
    before_action :check_admin_user, only: [:create, :destroy]
    def index 
        intrests = Intrest.all
        if  intrests.empty?
            render json: {
                message:    "Intrests Not Found",
                intrests: []
            }, status: :not_found
        else
            render json: {
                message:    "Intrests Found",
                intrests: intrests.as_json(only: [:id, :name])
            }, status: :ok
        end
    end

    def show
        intrest = set_intrest
        if intrest
            render json: {
                message: "Intrest Found",
                intrest: intrest.as_json(only: [:id, :name])
            }, status: :ok
        else
            render json: {
                message: "Intrest Not Found",
                intrest: []
            }, status: :not_found
        end
    end

    def create
        intrest = Intrest.create(intrest_params)
        if intrest.save
            render json: {
                message: "Intrest Created successfully",
                intrest: intrest.as_json(only: [:id, :name])
            }, status: :created
        else
            render json: {
                message: "Intrest Unable to Create",
                error: intrest.errors.full_messages
            }, status: 422
        end
    end

    def destroy
        intrest = set_intrest
        if intrest.delete
            render json: {
                message: "Intrest Deleted Successfully",
                intrest: intrest.as_json(only: [:id, :name])
            }, status: :ok
        else
            render json: {
                message: "Intrest unable to Delete",
                error: intrest.errors.full_messages
            }, status: 422
        end
    end

    private
    def intrest_params
        params.require(:intrest).permit(:name)
    end

    def check_admin_user
        if logged_in_user.admin? || logged_in_user.role == "admin"
            return logged_in_user
        else
            render json: { message: "Dude You Don't have permission"
             }, status: 401
        end
    end

    def set_intrest
        intrest = Intrest.find_by(id: params[:id])
        if intrest
            return intrest
        end
    end
end
