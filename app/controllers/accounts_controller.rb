class AccountsController < ApplicationController
    skip_before_action :verify_authenticity_token
  
    def sms_confirm
        jwt_payload = JWT.decode(request.headers['token'], Rails.application.credentials.fetch(:secret_key_base)).first
        current_user = User.find(jwt_payload['sub'])
        sms_service = Twilio::SmsService.new(to: current_user.phonenumber, pin: sms_verification_params[:pin])
        verification_check = sms_service.verify_otp

        render json: {
            message: "OTP Verified"
        }, status: :ok
    end
  
    private
  
    def sms_verification_params
      params.require(:verify).permit(:pin)
    end
end
