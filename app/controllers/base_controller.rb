class BaseController < ActionController::API
    private
    def logged_in_user
        jwt_payload = JWT.decode(request.headers['token'], ENV['secret_key_base']).first
        @current_user = User.find(jwt_payload['sub'])
        @logged_user_token = request.headers['token']
        if  @current_user.academic.present?
            if @current_user.token == @logged_user_token
                return @current_user
            else
                render json: {
                    message: "no Active Session for this current User"
                }, status: 401
            end
        else
            render json: {
                message: "Dude complete the academic First"
            }, status: 401
        end
    end

    def current_log
        jwt_payload = JWT.decode(request.headers['token'], ENV['secret_key_base']).first
        @current_user = User.find(jwt_payload['sub'])
        if @current_user
            return @current_user
        else
            render json: {
                message: "no Active Session for this current User"
            }, status: 401
        end
    end
end
