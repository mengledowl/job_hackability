require 'test_helper'

class JobListingFilterTest < ActiveSupport::TestCase
  test "filter_by favorite" do
    assert_equal 2, JobListing.filter_by(:favorite).size
  end

  test "filter_by remote" do
    assert_equal 1, JobListing.filter_by(:remote).size
  end

  test "filter_by status of interviewing" do
    assert_equal 2, JobListing.filter_by(:interviewing).size
  end

  test "filter_by multiple statuses" do
    assert_equal 3, JobListing.filter_by(:interviewing, :offer_received).size
  end

  test "filter_by remote and interviewing" do
    assert_equal 1, JobListing.filter_by(:interviewing, :remote).size
  end

  test "filter_by and where" do
    assert_equal 1, JobListing.filter_by(:interviewing).where(user: users(:one)).size
  end
end