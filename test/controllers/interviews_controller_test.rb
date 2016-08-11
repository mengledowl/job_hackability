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

  test "should create new" do
    interviews_size = Interview.count

    @controller.stub(:job_listing, job_listings(:one)) do
      post :create, job_listing_id: job_listings(:one).id, time_zone: 'Central Time (US & Canada)', interview: {
          "scheduled_at(1i)": "2016",
          "scheduled_at(2i)": "8",
          "scheduled_at(3i)": "9",
          "scheduled_at(4i)": "02",
          "scheduled_at(5i)": "20"
      }
    end

    interview = Interview.all.order(:created_at).last

    assert_response 302
    assert_equal interviews_size + 1, Interview.count
    assert_equal Time.parse('2016-8-9 02:20').in_time_zone('Central Time (US & Canada)'), interview.scheduled_at.in_time_zone('Central Time (US & Canada)')
  end
end
