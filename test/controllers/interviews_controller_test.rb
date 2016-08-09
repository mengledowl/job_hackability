require 'test_helper'

class InterviewsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    sign_in(users(:one))
  end

  test "should get new" do
    get :new, job_listing_id: job_listings(:one).id
    assert_response :success
  end
end
