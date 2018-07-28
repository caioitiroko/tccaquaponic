require 'test_helper'

class LinearRegressionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get linear_regression_index_url
    assert_response :success
  end

  test "should get result" do
    get linear_regression_result_url
    assert_response :success
  end

end
