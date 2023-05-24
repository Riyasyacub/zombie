class UsersController < ApplicationController
  before_action :set_users, only: :index
  before_action :set_user, only: %i(show update destroy)

  def index
  end

  def show
  end

  def create
    @user = User.new(user_create_params)
    unless @user.save
      render json: { errors: @user.errors_to_hash }, status: :unprocessable_entity
    end
  end

  def update
    unless @user.update(user_update_params)
      render json: { errors: @user.errors_to_hash }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render json: { message: "User deleted successfully" }
    else
      render json: { errors: @user.errors_to_hash }, status: :unprocessable_entity
    end
  end

  private

  def set_users
    @users = User.all
  end

  def set_user
    @user = User.find_by(id: params[:id])
    return if @user.present?
    render json: { message: "User not found" }, status: :not_found
  end

  def user_create_params
    params.permit(:name, :age, :gender, :latitude, :longitude, items: {})
  end

  def user_update_params
    params.permit( :latitude, :longitude)
  end
end
