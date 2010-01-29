require 'test_helper'

class EducationLevelsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:education_levels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create education_level" do
    assert_difference('EducationLevel.count') do
      post :create, :education_level => { }
    end

    assert_redirected_to education_level_path(assigns(:education_level))
  end

  test "should show education_level" do
    get :show, :id => education_levels(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => education_levels(:one).to_param
    assert_response :success
  end

  test "should update education_level" do
    put :update, :id => education_levels(:one).to_param, :education_level => { }
    assert_redirected_to education_level_path(assigns(:education_level))
  end

  test "should destroy education_level" do
    assert_difference('EducationLevel.count', -1) do
      delete :destroy, :id => education_levels(:one).to_param
    end

    assert_redirected_to education_levels_path
  end
end
