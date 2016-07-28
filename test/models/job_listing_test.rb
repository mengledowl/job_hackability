require 'test_helper'

class JobListingTest < ActiveSupport::TestCase
  def setup
    @job_listing = JobListing.new
  end

  test "should have unique urls per user" do
    @job_listing.url = 'sampleurl.com' # duplicate
    @job_listing.user_id = 1

    assert_raises(Exception) { @job_listing.save! }
  end

  test "should allow duplicate urls for different users" do
    @job_listing.url = 'sampleurl.com'
    @job_listing.user_id = 2

    assert_nothing_raised { @job_listing.save! }
  end
end
