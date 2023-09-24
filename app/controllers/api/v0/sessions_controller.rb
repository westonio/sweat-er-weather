class Api::V0::SessionsController < ApplicationController
  def create
    begin
      render json: UsersSerializer.new(find_and_validate_user), status: :ok
    rescue StandardError => e
      render json: ErrorsSerializer.new(e).serialized_json, status: :unauthorized
    end
  end

  private 
    def user_params
      params.permit(:email, :password)
    end

    def find_and_validate_user
      user = User.find_by_email(user_params[:email])
      raise "Invalid email and/or password combination. Please Try again." unless user&.authenticate(user_params[:password])
      user
    end
end