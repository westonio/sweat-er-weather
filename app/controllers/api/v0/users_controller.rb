class Api::V0::UsersController < ApplicationController

  def create
    begin
      # require 'pry'; binding.pry
      render json: UsersSerializer.new(User.create_with_api_key(user_params)), status: :created
    rescue StandardError => e
      require 'pry'; binding.pry
    end
  end

private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end