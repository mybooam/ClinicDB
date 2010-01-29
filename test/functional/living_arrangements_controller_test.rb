require 'test_helper'

class LivingArrangementsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:living_arrangements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create living_arrangement" do
    assert_difference('LivingArrangement.count') do
      post :create, :living_arrangement => { }
    end

    assert_redirected_to living_arrangement_path(assigns(:living_arrangement))
  end

  test "should show living_arrangement" do
    get :show, :id => living_arrangements(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => living_arrangements(:one).to_param
    assert_response :success
  end

  test "should update living_arrangement" do
    put :update, :id => living_arrangements(:one).to_param, :living_arrangement => { }
    assert_redirected_to living_arrangement_path(assigns(:living_arrangement))
  end

  test "should destroy living_arrangement" do
    assert_difference('LivingArrangement.count', -1) do
      delete :destroy, :id => living_arrangements(:one).to_param
    end

    assert_redirected_to living_arrangements_path
  end
end
