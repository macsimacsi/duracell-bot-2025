require "application_system_test_case"

class BannedsTest < ApplicationSystemTestCase
  setup do
    @banned = banneds(:one)
  end

  test "visiting the index" do
    visit banneds_url
    assert_selector "h1", text: "Banneds"
  end

  test "creating a Banned" do
    visit banneds_url
    click_on "New Banned"

    fill_in "Document", with: @banned.document
    click_on "Create Banned"

    assert_text "Banned was successfully created"
    click_on "Back"
  end

  test "updating a Banned" do
    visit banneds_url
    click_on "Edit", match: :first

    fill_in "Document", with: @banned.document
    click_on "Update Banned"

    assert_text "Banned was successfully updated"
    click_on "Back"
  end

  test "destroying a Banned" do
    visit banneds_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Banned was successfully destroyed"
  end
end
