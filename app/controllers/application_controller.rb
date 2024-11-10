class ApplicationController < ActionController::API
  before_action :authorize

  SECRET_KEY = Rails.application.secret_key_base

  def decode_token
    auth_header = request.headers["Authorization"]
    if auth_header
      token = auth_header.split(" ")[1]
      begin
        JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user
    decoded_token = decode_token
    if decoded_token
      user_id = decoded_token[0]["user_id"]
      @current_user = User.find_by(id: user_id)
    end
  end

  def authorize
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end
end
