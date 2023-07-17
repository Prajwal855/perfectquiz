class ChoicesController < BaseController
    before_action :logged_in_user
    def index 
        if logged_in_user.academic.present?
            choices = Choice.all
            if  choices.empty?
                render json: {
                    message:    "Choices Not Found",
                    choices: []
                }, status: :not_found
            else
                render json: {
                    message:    "Choices Found",
                    choices:   choices.as_json(only: [:id, :option, :question_id])
                }, status: :ok
            end
        else
            render json: { message: "Dude Complete the Academic Form First"
                }, status: 401
        end
    end

    def show
        if logged_in_user.academic.present?
            choice = set_choice
            if choice
                render json: {
                    message: "Choice Found",
                    choice: choice.as_json(only: [:id, :option, :question_id])
                }, status: :ok
            else
                render json: {
                    message: "Choice Not Found",
                    choice: []
                }, status: :not_found
            end
        else
            render json: { message: "Dude Complete the Academic Form First"
                }, status: 401
        end
    end

    def create
        if logged_in_user.admin? || logged_in_user.role == "admin" || logged_in_user.role == "teacher"
            choice = Choice.create(choice_params)
            if choice.save
                render json: {
                    message: "Choice Created successfully",
                    choice: choice.as_json(only: [:id, :option, :question_id])
                }, status: :created
            else
                render json: {
                    message: "Choice Unable to Create",
                    error: choice.errors.full_messages
                }, status: 422
            end
        else
            render json: { message: "Dude You Don't Have Permission"
                }, status: 401
        end
    end

    def update
        if logged_in_user.academic.present?
            choice = set_choice
            if choice.update(choice_params)
                render json: {
                    message: "Choice Updated Successfully",
                    choice: choice.as_json(only: [:id, :option, :question_id])
                }, status: :ok
            else
                render json: {
                    message: "Choice Unable to Update",
                    error: choice.errors.full_messages
                }, status: 422
            end
        else
            render json: { message: "Dude Complete the Academic Form First"
                }, status: 401
        end
    end

    def destroy
        if logged_in_user.academic.present?
            choice = set_choice
            if choice.delete
                render json: {
                    message: "Choice Deleted Successfully",
                    choice: choice.as_json(only: [:id, :option, :question_id])
                }, status: :ok
            else
                render json: {
                    message: "Choice unable to Delete",
                    error: choice.errors.full_messages
                }, status: 422
            end
        else
            render json: { message: "Dude Complete the Academic Form First"
                }, status: 401
        end
    end

    private
    def choice_params
        params.require(:choice).permit(:option, :question_id)
    end

    def set_choice
        choice = Choice.find_by(id: params[:id])
        if choice
            return choice
        end
    end
end
