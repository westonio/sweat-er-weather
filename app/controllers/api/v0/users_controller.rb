class Api::V0::UsersController < ApplicationController
  def new; end

  def create
    begin
      render json: UsersSerializer.new(User.create!(user_params)), status: :created
    rescue StandardError => e
      require 'pry'; binding.pry
    end
  end

private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end