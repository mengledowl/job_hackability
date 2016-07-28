require 'test_helper'

module JobListingsControllerTest
  class IndexTest < ActionController::TestCase
    include Devise::TestHelpers

    def setup
      @controller = JobListingsController.new
    end

    test "should require authentication" do
      get :index
      assert_response :redirect
    end

    test "should list user's job listings" do
      sign_in(users(:one))
      get :index

      assert_response :success
    end
  end
end

