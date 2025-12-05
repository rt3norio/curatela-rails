require "test_helper"

class CurateladosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get curatelados_index_url
    assert_response :success
  end

  test "should get show" do
    get curatelados_show_url
    assert_response :success
  end

  test "should get new" do
    get curatelados_new_url
    assert_response :success
  end

  test "should get edit" do
    get curatelados_edit_url
    assert_response :success
  end
end
