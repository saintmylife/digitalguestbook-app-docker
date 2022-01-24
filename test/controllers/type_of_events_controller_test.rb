require 'test_helper'

class TypeOfEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @type_of_event = type_of_events(:one)
  end

  test "should get index" do
    get type_of_events_url
    assert_response :success
  end

  test "should get new" do
    get new_type_of_event_url
    assert_response :success
  end

  test "should create type_of_event" do
    assert_difference('TypeOfEvent.count') do
      post type_of_events_url, params: { type_of_event: {  } }
    end

    assert_redirected_to type_of_event_url(TypeOfEvent.last)
  end

  test "should show type_of_event" do
    get type_of_event_url(@type_of_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_type_of_event_url(@type_of_event)
    assert_response :success
  end

  test "should update type_of_event" do
    patch type_of_event_url(@type_of_event), params: { type_of_event: {  } }
    assert_redirected_to type_of_event_url(@type_of_event)
  end

  test "should destroy type_of_event" do
    assert_difference('TypeOfEvent.count', -1) do
      delete type_of_event_url(@type_of_event)
    end

    assert_redirected_to type_of_events_url
  end
end
