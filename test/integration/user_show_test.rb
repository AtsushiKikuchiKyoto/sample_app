require "test_helper"

class UsersShowTest < ActionDispatch::IntegrationTest

  def setup
    @activated_user = users(:archer)
    @inactivated_user = users(:inactive)
  end

  test "should redirect when user not activated" do
    get user_path(@inactivated_user)
    assert_response :found #????????
    assert_redirected_to root_url
  end

  test "should display user when activated" do
    get user_path(@activated_user)
    assert_response :ok
    assert_template 'users/show'
  end
end