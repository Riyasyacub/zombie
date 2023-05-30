require 'test_helper'

class TradesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user1 = users(:user_1)
    @user2 = users(:user_2)
  end

  test "should create trade successfully" do
    trade_params = {
      from: { id: @user1.id, items: [{ name: 'AK47', quantity: 3 }] },
      to: { id: @user2.id, items: [{ name: 'Campbell Soup', quantity: 2 }] }
    }
    post trades_path, params: trade_params
    assert_response :success
    assert_equal "Trade Successful", JSON.parse(response.body)['message']
  end

  test "should render error if from user not found" do
    trade_params = {
      from: { id: 123, items: [{ name: 'AK47', quantity: 3 }] },
      to: { id: @user2.id, items: [{ name: 'Campbell Soup', quantity: 2 }] }
    }
    post trades_path, params: trade_params
    assert_response :not_found
    assert_equal "From user not found", JSON.parse(response.body)['message']
  end

  test "should render error if to user not found" do
    trade_params = {
      from: { id: @user1.id, items: [{ name: 'AK47', quantity: 3 }] },
      to: { id: 123, items: [{ name: 'Campbell Soup', quantity: 2 }] }
    }
    post trades_path, params: trade_params
    assert_response :not_found
    assert_equal "To user not found", JSON.parse(response.body)['message']
  end

  test "should render error if users are infected" do
    @user1.update(infected: true)
    trade_params = {
      from: { id: @user1.id, items: [{ name: 'AK47', quantity: 3 }] },
      to: { id: @user2.id, items: [{ name: 'Campbell Soup', quantity: 2 }] }
    }
    post trades_path, params: trade_params
    assert_response :unprocessable_entity
    assert_equal "Infected user cannot perform trade", JSON.parse(response.body)['message']
  end

  test "should render error if trade items are invalid" do
    trade_params = {
      from: { id: @user1.id, items: [{ name: 'AK47', quantity: 9 }] },
      to: { id: @user2.id, items: [{ name: 'Campbell Soup', quantity: 10 }] }
    }
    post trades_path, params: trade_params
    assert_response :unprocessable_entity
    assert_equal "from user does not contains 9 units of AK47s ", JSON.parse(response.body)['errors'][0]
    assert_equal "to user does not contains 10 units of Campbell Soups ", JSON.parse(response.body)['errors'][1]
  end

  test "should render error if trade items are not present" do
    trade_params = {
      from: { id: @user1.id },
      to: { id: @user2.id, items: [] }
    }
    post trades_path, params: trade_params
    assert_response :unprocessable_entity
    assert_equal "Trade items must be present for from user", JSON.parse(response.body)['errors'][0]
    assert_equal "Trade items must be present for to user", JSON.parse(response.body)['errors'][1]
  end

  test "should render error if points of items are not equal for trade" do
    trade_params = {
      from: { id: @user1.id, items: [{ name: 'AK47', quantity: 4 }] },
      to: { id: @user2.id, items: [{ name: 'Campbell Soup', quantity: 2 }] }
    }
    post trades_path, params: trade_params
    assert_response :unprocessable_entity
    assert_equal "Points of items of both users must be equal to trade", JSON.parse(response.body)['message']
  end
end
