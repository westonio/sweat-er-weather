class Api::V0::UsersController < ApplicationController

  def create
    begin
      render json: UsersSerializer.new(User.create!(user_params)), status: :created
    rescue StandardError => e
      render json: ErrorsSerializer.new(e).serialized_json, status: :bad_request
    end
  end

private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end