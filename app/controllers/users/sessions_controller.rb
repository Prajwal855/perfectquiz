# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json
  
  def respond_with(resource, _opts = {})
    if @user && @user.academic.present? && @user.valid_password?(params[:user][:password])
      sign_in @user
      token = request.env['warden-jwt_auth.token']
          response_data = {
            message: "User logged In successfully",
            meta: {
              token: token
            } 
          }
          render json: response_data
      elsif @user && @user.valid_password?(params[:user][:password])
        token = request.env['warden-jwt_auth.token']
      render json: {  message: 'Dude Fill Academic Record First.',
                    token: token
                }, status: :not_found

      else
        render json:{ message: "invalid password"}, status: 401
      end
  end

  def respond_to_on_destroy
    jwt_payload = JWT.decode(request.headers['token'], Rails.application.credentials.fetch(:secret_key_base)).first
    current_user = User.find(jwt_payload['sub'])
    if current_user
      render json: {
        status: 200,
        message: "logged out successfully"
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
