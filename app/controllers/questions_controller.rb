class QuestionsController < ApplicationController
    before_action :authenticate_user!
    def index 
        questions = Question.all
        if questions.empty?
            render json: {
                message: "Questions Not Found",
                questions: []
            }, status: :not_found
        else
            render json: {
                message: "Questions Found",
                questions: questions
            }, status: :ok
        end
    end
    def show
        question = set_question
        if question
            render json: {
                message: "Question Found",
                question: question
            }, status: :ok
        else
            render json: {
                message: "Question Not Found",
                question: []
            }, status: :not_found
        end
    end

    def filtered_questions
        difficult = params[:difficult]
        lang = params[:lang]
        @questions = Question.where("language like ? AND level like ?","%#{lang}%","%#{difficult}%" )
        if @questions.empty?
            render json: {
                message: "No Questions Found With the #{params[:difficult]} with #{params[:lang]}",
                question: []
            }, status: :not_found
        else
            render json:{
                message: "Questions Based on the #{params[:difficult]} and #{params[:lang]}",
                questions: @questions.as_json(only: [:id, :que], include: { choices: { only: :option } }) 
            }, status: :ok
        end
    end

    def submit_answers
        if current_user.role == "user"
            submitted_answers = params[:answers]
        
            total_questions = submitted_answers.length
            correct_answers = 0
        
            submitted_answers.each do |answer|
            question = Question.find(answer[:question_id])
            selected_option = Choice.find(answer[:option_id]) if answer[:option_id].present?
        
            if selected_option.present? && selected_option.option == question.correct_answer
                correct_answers += 1
            end
            end
        
            score = (correct_answers.to_f / total_questions) * 100
        
            render json: { 
                message: "You Have Scored",
                score: score, 
                correct_answers: correct_answers, 
                total_questions: total_questions 
            }
        else
            render json: { message: "Dude You Don't have permission"
            }, status: 401
        end
    end

    def create
        if current_user.role == "admin"
            question = Question.create(question_params)
            if question.save
                render json: {
                    message: "Question Created successfully",
                    question: question
                }, status: :created
            else
                render json: {
                    message: "Question Unable to Create",
                    error: question.errors.full_messages
                }, status: 422
            end
        else
            render json: { message: "Dude You Don't have permission"
                }, status: 401
        end
    end
    def update
        question = set_question
        if question.update(question_params)
            render json: {
                message: "Question Updated Successfully",
                question: question
            }, status: :ok
        else
            render json: {
                message: "Question Unable to Update",
                error: question.errors.full_messages
            }, status: 422
        end
    end
    def destroy
        question = set_question
        if question.delete
            render json: {
                message: "Question Deleted Successfully",
                question: question
            }, status: :ok
        else
            render json: {
                message: "Question unable to Delete",
                error: question.errors.full_messages
            }, status: 422
        end
    end

    private
    def question_params
        params.require(:question).permit(:que, :correct_answer, :level, :language)
    end

    def submited_answer
        params.require(:submite_answer).permit(:question_id, :answer) 
    end

    def set_question
        question = Question.find_by(id: params[:id])
        if question
            return question
        end
    end
end
