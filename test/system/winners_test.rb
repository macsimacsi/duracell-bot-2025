require "application_system_test_case"

class WinnersTest < ApplicationSystemTestCase
  setup do
    @winner = winners(:one)
  end

  test "visiting the index" do
    visit winners_url
    assert_selector "h1", text: "Winners"
  end

  test "creating a Winner" do
    visit winners_url
    click_on "New Winner"

    fill_in "Gas stations detail", with: @winner.gas_stations_detail_id
    fill_in "Participation", with: @winner.participation_id
    fill_in "Status", with: @winner.status
    click_on "Create Winner"

    assert_text "Winner was successfully created"
    click_on "Back"
  end

  test "updating a Winner" do
    visit winners_url
    click_on "Edit", match: :first

    fill_in "Gas stations detail", with: @winner.gas_stations_detail_id
    fill_in "Participation", with: @winner.participation_id
    fill_in "Status", with: @winner.status
    click_on "Update Winner"

    assert_text "Winner was successfully updated"
    click_on "Back"
  end

  test "destroying a Winner" do
    visit winners_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Winner was successfully destroyed"
  end
end
