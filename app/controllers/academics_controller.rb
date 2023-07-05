class AcademicsController < ApplicationController
    before_action :current_user
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
        academic = Academic.find_by(id: params[:id])
        if academic
            return academic
        end
    end

    def academics_params
        params.permit(:college_name, :intrest_id, :qualification_id,
            :career_goals, :language, :other_language, :specialization,:currently_working,
            :availability,:experiance, :user_id, :cv, :governament_id)
    end

    def current_user
        jwt_payload = JWT.decode(request.headers['token'], Rails.application.credentials.fetch(:secret_key_base)).first
        current_user = User.find(jwt_payload['sub'])
        if current_user
            return current_user
        end
    end
end
