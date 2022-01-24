require 'test_helper'

class AbsensiControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get absensi_index_url
    assert_response :success
  end

end
