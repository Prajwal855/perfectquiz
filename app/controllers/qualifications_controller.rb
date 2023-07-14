class QualificationsController < ApplicationController
    before_action :current_user
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
        if current_user.academic.present?
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
        else
            render json: { message: "Dude Complete the Academic Form First"
                }, status: 401
        end
    end

    def create
        if current_user.admin?
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
        else
            render json: { message: "Dude You Don't have permission"
                }, status: 401
        end
    end


    def destroy
        if current_user.academic.present?
            if current_user.role == 'admin'
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
    def qualification_params
        params.require(:qualification).permit(:name)
    end

    def set_qualification
        qualification = Qualification.find_by(id: params[:id])
        if qualification
            return qualification
        end
    end
end
