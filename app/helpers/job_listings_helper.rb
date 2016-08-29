module JobListingsHelper
  def filter_options
    {
        Misc: [['Remote', 'remote'], ['Favorite', 'favorite']],
        Status: JobListing::STATUS_VALUES.collect { |s| [s.humanize, s] }
    }
  end
end
