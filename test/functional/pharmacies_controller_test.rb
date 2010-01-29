require 'test_helper'

class PharmaciesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pharmacies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pharmacy" do
    assert_difference('Pharmacy.count') do
      post :create, :pharmacy => { }
    end

    assert_redirected_to pharmacy_path(assigns(:pharmacy))
  end

  test "should show pharmacy" do
    get :show, :id => pharmacies(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pharmacies(:one).to_param
    assert_response :success
  end

  test "should update pharmacy" do
    put :update, :id => pharmacies(:one).to_param, :pharmacy => { }
    assert_redirected_to pharmacy_path(assigns(:pharmacy))
  end

  test "should destroy pharmacy" do
    assert_difference('Pharmacy.count', -1) do
      delete :destroy, :id => pharmacies(:one).to_param
    end

    assert_redirected_to pharmacies_path
  end
end
