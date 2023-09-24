class Api::V0::SessionsController < ApplicationController
  def create
    begin
      render json: UsersSerializer.new(find_and_validate_user)
    rescue StandardError => e
      require 'pry'; binding.pry
    end
  end

  private 
    def user_params
      params.permit(:email, :password)
    end

    def find_and_validate_user
      user = User.find_by_email(user_params[:email])
      raise "Invalid credentials. Please Try again." unless user&.authenticate(user_params[:password])
      user
    end
end