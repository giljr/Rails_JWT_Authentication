class ApplicationController < ActionController::API
    before_action :authorized

    def encode_token(payload)
        JWT.encode(payload, "hellomars1211")
    end

    def decoded_token
        header = request.headers["Authorization"]
        if header
            token = header.split(" ")[1]
            begin
                JWT.decode(token, "hellomars1211")
            rescue JWT::DecodeError
                nil
            end
        end
    end

    def current_user
    return @user if defined?(@user)

    payload = decoded_token&.first
    @user = payload ? User.find_by(id: payload["user_id"]) : nil
    end


    def authorized
        unless !!current_user
        render json: { message: "Please log in" }, status: :unauthorized
        end
    end
end
