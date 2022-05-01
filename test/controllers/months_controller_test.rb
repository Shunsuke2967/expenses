require 'test_helper'

class MonthsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get months_index_url
    assert_response :success
  end

  test "should get new" do
    get months_new_url
    assert_response :success
  end

end
