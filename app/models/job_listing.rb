class JobListing < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  before_create :scrape_attributes

  validates_presence_of :url
  validates_uniqueness_of :url, scope: :user

  def scraper
    @scraper ||= Scraper.new(url).scrape
  end

  # todo: only set these values when they aren't already set & settable (eg. raw_scraping_data isn't setable)
  def scrape_attributes
    self.raw_scraping_data = scraper.html
    self.company = scraper.company
    self.description = scraper.description
    self.apply_details = scraper.apply_details
    self.apply_link = scraper.apply_link
    self.position = scraper.position
    self.posted_date = scraper.posted_date
    self.company_website = scraper.company_website
  end
end
