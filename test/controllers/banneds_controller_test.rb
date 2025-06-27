require "test_helper"

class BannedsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @banned = banneds(:one)
  end

  test "should get index" do
    get banneds_url
    assert_response :success
  end

  test "should get new" do
    get new_banned_url
    assert_response :success
  end

  test "should create banned" do
    assert_difference('Banned.count') do
      post banneds_url, params: { banned: { document: @banned.document } }
    end

    assert_redirected_to banned_url(Banned.last)
  end

  test "should show banned" do
    get banned_url(@banned)
    assert_response :success
  end

  test "should get edit" do
    get edit_banned_url(@banned)
    assert_response :success
  end

  test "should update banned" do
    patch banned_url(@banned), params: { banned: { document: @banned.document } }
    assert_redirected_to banned_url(@banned)
  end

  test "should destroy banned" do
    assert_difference('Banned.count', -1) do
      delete banned_url(@banned)
    end

    assert_redirected_to banneds_url
  end
end
