class JobListing < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  before_create :scrape_attributes

  validates_presence_of :url
  validates_uniqueness_of :url, scope: :user

  def scraped_values
    @scraped_values ||= scraper_adapter.new(url).scrape
  end

  def scraper_adapter
    @scraper_adapter ||= Scraper.adapter(url)
  end

  # todo: only set these values when they aren't already set & settable (eg. raw_scraping_data isn't setable)
  def scrape_attributes
    self.raw_scraping_data = scraped_values.html
    self.company = scraped_values.company
    self.description = scraped_values.description
    self.apply_details = scraped_values.apply_details
    self.apply_link = scraped_values.apply_link
    self.position = scraped_values.position
    self.posted_date = scraped_values.posted_date
    self.company_website = scraped_values.company_website

  rescue NoAdapterFoundError => e
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
end
