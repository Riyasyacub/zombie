require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user_1)
  end

  test "should get index" do
    get users_path
    assert_response :success
  end

  test "should create user" do
    assert_difference -> { User.count } => 1, -> { Resource.count } => 2 do
      post users_path, params: user_success_params.merge(items: { "Fiji Water": 10, "AK47": 2 })
    end
    assert_response :success
  end

  test "should not create user" do
    assert_difference -> { User.count } => 0 do
      post users_path, params: {}
    end
    assert_response 422
    response = JSON.parse(@response.body)
    errors   = response['errors']
    assert_equal errors['name'], "Name can't be blank"
    assert_equal errors['age'], "Age can't be blank"
    assert_equal errors['gender'], "Gender can't be blank"
    assert_equal errors['latitude'], "Latitude can't be blank"
    assert_equal errors['longitude'], "Longitude can't be blank"
  end

  test "should update user" do
    assert_difference -> { User.count } => 0 do
      patch user_path(id: @user.id), params: user_success_params
    end
    assert_response :success
    @user.reload
    assert_equal user_success_params[:latitude], @user.latitude
    assert_equal user_success_params[:longitude], @user.longitude
    assert_not_equal user_success_params[:name], @user.name
  end

  test "should not update user" do
    assert_difference -> { User.count } => 0 do
      patch user_path(id: @user.id), params: { name: "", age: nil, gender: "dummy", latitude: nil, longitude: "" }
    end
    assert_response 422
    response = JSON.parse(@response.body)
    errors   = response['errors']
    assert_equal errors['latitude'], "Latitude can't be blank"
    assert_equal errors['longitude'], "Longitude can't be blank"
  end

  test "should destroy user" do
    assert_difference -> { User.count } => -1 do
      delete user_path(id: @user.id)
    end
    assert_response :success
  end

  private

  def user_success_params
    {
      "name":      "John",
      "age":       26,
      "gender":    "male",
      "latitude":  34.877656,
      "longitude": 87.736476
    }
  end

  def user_failure_params
    {
      "name":      "John",
      "age":       24,
      "gender":    "maleieuf",
      "latitude":  34.877656,
      "longitude": 87.736476
    }
  end
end
