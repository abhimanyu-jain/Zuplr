require 'test_helper'

class StylistControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get deliveries" do
    get :deliveries
    assert_response :success
  end

end
