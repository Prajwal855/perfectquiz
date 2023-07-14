class BaseController < ActionController::API

    private
    def current_user
        jwt_payload = JWT.decode(request.headers['token'], ENV['secret_key_base']).first
        current_user = User.find(jwt_payload['sub'])
        if current_user
            return current_user
        end
    end
end
