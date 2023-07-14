class AccountsController < BaseController
  
    def sms_confirm
        begin
            jwt_payload = JWT.decode(request.headers['token'], ENV['secret_key_base']).first
            current_user = User.find(jwt_payload['sub'])
            sms_service = Twilio::SmsService.new(to: current_user.phonenumber, pin: sms_verification_params[:pin])
            verification_check = sms_service.verify_otp
            token = request.headers['token']
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
        rescue Twilio::REST::RestError => e
                Rails.logger.error("Twilio Error:")
                render json: { error: "Wrong Pin Dude!" }, status: 400
        rescue JWT::DecodeError => e
                Rails.logger.error("JWT Decode Error:")
                render json: { error: "Wrong Token Dude!" }, status: :unauthorized
        end
    end
  
    private
  
    def sms_verification_params
      params.permit(:pin)
    end
end
