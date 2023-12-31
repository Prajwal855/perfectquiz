# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  def respond_with(resource,opt={})
      build_resource(sign_up_params)
        if resource.valid?
            resource.save
            Twilio::SmsService.new(to: resource.phonenumber, pin: '').send_otp
            token = request.env['warden-jwt_auth.token']
            render json: {
              status: {code: 200, message: 'Signed up sucessfully.', token: token},
              meta: resource.as_json(only: [:id, :email, :role]),
            }
        else
          render json: {
            status: {message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
          }, status: :unprocessable_entity
        end
    rescue ArgumentError => e
        render json: { error: e.message }, status: :unprocessable_entity
  end

  def sign_up_params
      params.require(:user).permit(:email, :name, :password, :role, :phonenumber)
  end
#   def new
#     super do |resource|
#     resource.name = params[:user][:name]
#     resource.role = params[:user][:role]
#     resource.phonenumber = params[:user][:phonenumber]
#     resource.save
#    end
#  end
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
