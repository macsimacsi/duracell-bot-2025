require "application_system_test_case"

class ConversationsTest < ApplicationSystemTestCase
  setup do
    @conversation = conversations(:one)
  end

  test "visiting the index" do
    visit conversations_url
    assert_selector "h1", text: "Conversations"
  end

  test "creating a Conversation" do
    visit conversations_url
    click_on "New Conversation"

    fill_in "Contact", with: @conversation.contact
    fill_in "Last message at", with: @conversation.last_message_at
    fill_in "Last message", with: @conversation.last_message_id
    fill_in "Participant", with: @conversation.participant_id
    fill_in "Source", with: @conversation.source_id
    click_on "Create Conversation"

    assert_text "Conversation was successfully created"
    click_on "Back"
  end

  test "updating a Conversation" do
    visit conversations_url
    click_on "Edit", match: :first

    fill_in "Contact", with: @conversation.contact
    fill_in "Last message at", with: @conversation.last_message_at
    fill_in "Last message", with: @conversation.last_message_id
    fill_in "Participant", with: @conversation.participant_id
    fill_in "Source", with: @conversation.source_id
    click_on "Update Conversation"

    assert_text "Conversation was successfully updated"
    click_on "Back"
  end

  test "destroying a Conversation" do
    visit conversations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Conversation was successfully destroyed"
  end
end
