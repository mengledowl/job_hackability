class JobListing < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  validates_presence_of :url
  validates_uniqueness_of :url, scope: :user

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

  def scraper
    @scraper ||= Scraper.new(url).scrape
  end
end
