module InterviewsHelper
  def scheduled_at(interview)
    time_ago = time_ago_in_words(interview.scheduled_at.in_time_zone("Central Time (US & Canada)"))
    "#{time_ago} #{future_or_past_word(interview.scheduled_at)}"
  end

  private

  def future_or_past_word(date)
    date.future? ? 'away' : 'ago'
  end
end
