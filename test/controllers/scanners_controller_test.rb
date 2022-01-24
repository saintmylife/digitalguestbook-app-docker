require 'test_helper'

class ScannersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get scanners_index_url
    assert_response :success
  end

end
