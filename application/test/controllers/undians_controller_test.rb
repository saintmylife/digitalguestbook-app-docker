require 'test_helper'

class UndiansControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get undians_index_url
    assert_response :success
  end

end
