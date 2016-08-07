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

  # include force: true to reset all values based on scraped_values
  def scrape_attributes(*opts)
    opts = opts[0]

    force = opts ? opts[:force] : false

    self.raw_scraping_data  = scraped_values.html
    self.company            = scraped_values.company          unless self.company && !force
    self.description        = scraped_values.description      unless self.description && !force
    self.apply_details      = scraped_values.apply_details    unless self.apply_details && !force
    self.apply_link         = scraped_values.apply_link       unless self.apply_link && !force
    self.position           = scraped_values.position         unless self.position && !force
    self.posted_date        = scraped_values.posted_date      unless self.posted_date && !force
    self.company_website    = scraped_values.company_website  unless self.company_website && !force

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
