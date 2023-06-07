require "test_helper"

class TransitionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get transitions_index_url
    assert_response :success
  end
end
