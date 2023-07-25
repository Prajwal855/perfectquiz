class AcademicsController < BaseController
    before_action :current_log

    def index
        academics = Academic.all
        if academics.empty?
            render json: {
                message: "Academics Not Found",
                academics: []
            }, status: :not_found
        else
            render json: {
                message: "Academics Found",
                academics: DocumentSerializer.new(academics)
            }, status: :ok
        end        
    end

    def create
        academic = Academic.create(academics_params)
        if academic.save
            render json: {
                message: "Academic Created Successfully",
                academic: academic
            }, status: :created
        else
            render json: {
                message: "Academic Cannot be Created",
                academic: academic.errors.full_messages
            }, status: 422
        end
    end

    private
    def set_academic
        academic = Academic.find(id: params[:id])
        if academic
            return academic
        end
    end

    def academics_params
        params.permit(:college_name, :intrest_id, :qualification_id,
            :career_goals, :language, :other_language, :specialization,:currently_working,
            :availability,:experiance, :cv, :governament_id).merge(user_id: current_user.id)
    end
end
