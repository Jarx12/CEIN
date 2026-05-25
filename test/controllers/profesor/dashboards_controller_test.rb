require "test_helper"

class Profesor::DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get profesor_dashboards_show_url
    assert_response :success
  end
end
