require "test_helper"

class ParticipationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @participation = participations(:one)
  end

  test "should get index" do
    get participations_url
    assert_response :success
  end

  test "should get new" do
    get new_participation_url
    assert_response :success
  end

  test "should create participation" do
    assert_difference('Participation.count') do
      post participations_url, params: { participation: { city_id: @participation.city_id, document: @participation.document, full_name: @participation.full_name, gas_station_id: @participation.gas_station_id, img_path: @participation.img_path, participant_id: @participation.participant_id, product_id: @participation.product_id, quantity: @participation.quantity, status: @participation.status } }
    end

    assert_redirected_to participation_url(Participation.last)
  end

  test "should show participation" do
    get participation_url(@participation)
    assert_response :success
  end

  test "should get edit" do
    get edit_participation_url(@participation)
    assert_response :success
  end

  test "should update participation" do
    patch participation_url(@participation), params: { participation: { city_id: @participation.city_id, document: @participation.document, full_name: @participation.full_name, gas_station_id: @participation.gas_station_id, img_path: @participation.img_path, participant_id: @participation.participant_id, product_id: @participation.product_id, quantity: @participation.quantity, status: @participation.status } }
    assert_redirected_to participation_url(@participation)
  end

  test "should destroy participation" do
    assert_difference('Participation.count', -1) do
      delete participation_url(@participation)
    end

    assert_redirected_to participations_url
  end
end
