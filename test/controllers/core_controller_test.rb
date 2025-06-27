require "test_helper"

class CoreControllerTest < ActionDispatch::IntegrationTest
  test "should get generate_qr_code" do
    get core_generate_qr_code_url
    assert_response :success
  end
end
