require 'test_helper'

class TimeloggerControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get timepost" do
    get :timepost
    assert_response :success
  end

end
