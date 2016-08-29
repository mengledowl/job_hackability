class JobListing < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :interviews, after_add: :set_status_to_interviewing

  STATUS_VALUES = %w(no_interview_granted interviewing offer_received offer_declined no_offer_given)
  BOOL_FILTERS = ['remote', 'favorite']
  ALLOWED_FILTERS = [*STATUS_VALUES, *BOOL_FILTERS]

  before_create :scrape_attributes

  validate :url_is_url
  validates_uniqueness_of :url, scope: :user, allow_blank: true

  validates_inclusion_of :status, in: STATUS_VALUES, message: 'not recognized', allow_blank: true

  validate :presence_of_identifier

  paginates_per 12

  def self.filter_by(*opts)
    listings = self
    statuses = []
    opts = opts.map(&:to_s)

    opts.each do |option|
      if option.in? BOOL_FILTERS
        listings = listings.where(option.to_sym => true)
      elsif option.in? STATUS_VALUES
        statuses << option.to_s
      end
    end

    statuses.empty? ? listings : listings.where(status: statuses)
  end

  def scraped_values
    @scraped_values ||= scraper_adapter.new(url).scrape
  end

  def scraper_adapter
    @scraper_adapter ||= Scraper.adapter(url)
  end

  # include force: true to reset all values based on scraped_values
  def scrape_attributes(*opts)
    opts = opts[0]

    force = opts ? opts[:force] : false

    self.raw_scraping_data  = scraped_values.html
    self.company            = scraped_values.company          unless self.company.present? && !force
    self.description        = scraped_values.description      unless self.description.present? && !force
    self.apply_details      = scraped_values.apply_details    unless self.apply_details.present? && !force
    self.apply_link         = scraped_values.apply_link       unless self.apply_link.present? && !force
    self.position           = scraped_values.position         unless self.position.present? && !force
    self.posted_date        = scraped_values.posted_date      unless self.posted_date.present? && !force
    self.company_website    = scraped_values.company_website  unless self.company_website.present? && !force
    self.remote             = scraped_values.remote           unless self.remote.present? && !force
    self.location           = scraped_values.location         unless self.location.present? && !force

  rescue NoAdapterFoundError => e
    nil
  rescue ArgumentError => e
    nil
  end

  def display_name
    return title if title.present?
    position_at_company || url
  end

  def position_at_company
    return "#{position} at #{company}" if position.present? && company.present?
    nil
  end

  def set_status_to_interviewing(interview)
    if interviews.size == 1
      self.status = :interviewing
    end
  end

  private

  def presence_of_identifier
    return true if [url, title, company].compact.size >= 1

    errors.add(:base, 'Must set either the url, title, or company')
  end

  def url_is_url
    self.url = Scraper.format_and_validate_url(self.url) if url.present?

  rescue ArgumentError => e
    errors.add(:url, 'is invalid')
  end
end
