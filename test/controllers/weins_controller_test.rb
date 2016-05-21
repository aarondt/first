require 'test_helper'

class WeinsControllerTest < ActionController::TestCase
  setup do
    @wein = weins(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:weins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wein" do
    assert_difference('Wein.count') do
      post :create, wein: { image_url: @wein.image_url, name: @wein.name, price: @wein.price, vintage: @wein.vintage }
    end

    assert_redirected_to wein_path(assigns(:wein))
  end

  test "should show wein" do
    get :show, id: @wein
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wein
    assert_response :success
  end

  test "should update wein" do
    patch :update, id: @wein, wein: { image_url: @wein.image_url, name: @wein.name, price: @wein.price, vintage: @wein.vintage }
    assert_redirected_to wein_path(assigns(:wein))
  end

  test "should destroy wein" do
    assert_difference('Wein.count', -1) do
      delete :destroy, id: @wein
    end

    assert_redirected_to weins_path
  end
end
