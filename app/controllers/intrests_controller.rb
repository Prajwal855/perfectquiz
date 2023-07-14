class IntrestsController < ApplicationController
    before_action :current_user
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
        if current_user.academic.present?
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
        else
            render json: { message: "Dude Complete the Academic Form First"
                }, status: 401
        end
    end

    def create
        if current_user.admin?
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
        else
            render json: { message: "Dude You Don't have permission"
                }, status: 401
        end
    end

    def destroy
        if current_user.academic.present?
            if current_user.role == 'admin'
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
    def intrest_params
        params.require(:intrest).permit(:name)
    end

    def set_intrest
        intrest = Intrest.find_by(id: params[:id])
        if intrest
            return intrest
        end
    end
end
