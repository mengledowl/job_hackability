require 'test_helper'

class InterviewTest < ActiveSupport::TestCase
  test "should only allow 1-3 for how_it_went" do
    interview_0 = Interview.new(how_it_went: 0)
    interview_negative = Interview.new(how_it_went: -1)
    interview_1 = Interview.new(how_it_went: 1)
    interview_3 = Interview.new(how_it_went: 3)
    interview_4 = Interview.new(how_it_went: 4)

    assert_not interview_0.valid?
    assert_not interview_negative.valid?
    assert interview_1.valid?
    assert interview_3.valid?
    assert_not interview_4.valid?
  end

  test "should allow how_it_went to be nil" do
    interview = Interview.new

    assert interview.valid?
  end
end
