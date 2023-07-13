class AccountsController < ApplicationController
    skip_before_action :verify_authenticity_token
  
    def sms_confirm
        jwt_payload = JWT.decode(request.headers['token'], Rails.application.credentials.secret_key_base)
        current_user = User.find(jwt_payload['sub'])
        sms_service = Twilio::SmsService.new(to: current_user.phonenumber, pin: sms_verification_params[:pin])
        verification_check = sms_service.verify_otp
        token = request.headers['token'], Rails.application.credentials.secret_key_base
        if verification_check == {:status=>"approved"}
            current_user.update(otp_verified: true)
            render json: {
                message: "OTP Verified",
                token: token
            }, status: :ok
        else
            render json: {
                message: "Wrong Otp Please Try Again...."
            }, status: 404
        end
    end
  
    private
  
    def sms_verification_params
      params.require(:verify).permit(:pin)
    end
end
