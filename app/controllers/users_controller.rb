class UsersController < ApplicationController
  include Docs::UsersControllerDocs
  before_action :set_users, only: :index
  before_action :set_user, only: %i(show update destroy)

  def_param_group :user_details do
    param :name, String, required: true
    param :age, Integer, required: true
    param :gender, String, required: true
    param :latitude, Float, required: true
    param :longitude, Float, required: true
  end

  api :GET, '/users', "Users details"
  error code: 500, desc: 'Internal Server Error'
  returns array_of: :user_details, code: 200, desc: "List of users"
  users_index

  def index
  end

  api :GET, '/users/:id', "User Details"
  param :id, String, required: true, desc: "Id of the user"
  error code: 500, desc: 'Internal Server Error'
  error code: 404, desc: 'User Not Found'
  error code: 422, desc: 'Validation Errors'
  returns :user_details, code: 200, desc: "User Details"
  user_show

  def show
  end

  api :POST, '/users', "Create User"
  param :id, String, required: true, desc: "Id of the user"
  error code: 500, desc: 'Internal Server Error'
  error code: 422, desc: 'Validation Errors'
  param :name, String, required: true
  param :age, Integer, required: true
  param :gender, String, required: true
  param :latitude, Float, required: true
  param :longitude, Float, required: true
  param :items, Hash, required: true
  returns :user_details, code: 200, desc: "Created User Details"
  user_create

  def create
    @user = User.new(user_create_params)
    unless @user.save
      render json: { errors: @user.errors_to_hash }, status: :unprocessable_entity
    end
  end

  api :PATCH, '/users/:id', "Update User"
  param :id, String, required: true, desc: "Id of the user"
  error code: 500, desc: 'Internal Server Error'
  error code: 404, desc: 'User Not Found'
  error code: 422, desc: 'Validation Errors'
  param :latitude, Float, required: false
  param :longitude, Float, required: false
  param :infected, String, required: false
  returns :user_details, code: 200, desc: "Update User Details"
  user_update

  def update
    unless @user.update(user_update_params)
      render json: { errors: @user.errors_to_hash }, status: :unprocessable_entity
    end
  end

  api :DELETE, '/users/:id', "Delete User"
  param :id, String, required: true, desc: "Id of the user"
  error code: 500, desc: 'Internal Server Error'
  error code: 404, desc: 'User Not Found'
  user_destroy
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
    params.permit( :latitude, :longitude, :infected)
  end
end
