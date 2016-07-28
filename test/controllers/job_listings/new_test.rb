require 'test_helper'

module JobListingsControllerTest
  class NewTest < ActionController::TestCase
    include Devise::TestHelpers

    def setup
      @controller = JobListingsController.new
    end

    test "should require authentication" do
      get :new
      assert_response :redirect
    end

    test "should return 'new' page successfully" do
      sign_in(users(:one))
      get :new

      assert_response :success
    end
  end
end