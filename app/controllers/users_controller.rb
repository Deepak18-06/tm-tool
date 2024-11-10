class UsersController < ApplicationController
  skip_before_action :authorize, only: [ :signup, :login ]

  SECRET_KEY = Rails.application.secret_key_base

  def signup
    user = User.new(user_params)
    if user.save
      render json: { message: "User created successfully" }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:user][:email])
    if user&.authenticate(params[:user][:password])
      token = encode_token(user_id: user.id)
      render json: { token: token, message: "Login successful" }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end
end
