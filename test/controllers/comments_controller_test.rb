require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    sign_in(users(:one))
  end

  test "should create comment for job listing" do
    comment_size = Comment.count
    post :create, job_listing_id: job_listings(:one).id, comment: { value: 'comment' }

    assert_equal comment_size + 1, Comment.count
    assert_equal Comment.last.value, 'comment'
  end

  test "should add comment to interview if interview_id included" do
    comment_size = Comment.count
    post :create, job_listing_id: job_listings(:one).id, interview_id: interviews(:one).id, comment: { value: 'interview comment' }

    assert_equal comment_size + 1, Comment.count
    assert_equal 'interview comment', Comment.last.value
    assert_equal interviews(:one), Comment.last.interview
  end
end
