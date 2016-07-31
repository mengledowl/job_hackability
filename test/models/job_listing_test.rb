require 'test_helper'
require 'yaml'

class JobListingTest < ActiveSupport::TestCase
  def setup
    @job_listing = JobListing.new
    @scraper_attributes = YAML.load(ERB.new(File.read('test/files/scraper.yml')).result)['we_work_remotely']
  end

  test "should have unique urls per user" do
    @job_listing.url = 'sampleurl.com' # duplicate
    @job_listing.user_id = 1

    assert_not @job_listing.valid?
    assert_raises(ActiveRecord::RecordInvalid) { @job_listing.save! }
  end

  test "should allow duplicate urls for different users" do
    @job_listing.url = 'sampleurl.com'
    @job_listing.user_id = 2

    assert @job_listing.valid?
  end

  test "scrape_attributes should set attributes from scraper" do
    @job_listing.url = @scraper_attributes['url']
    scrape = Scraper.new(@scraper_attributes['url'])

    @scraper_attributes.each { |k,v| scrape.send("#{k}=", v) }

    @job_listing.stub(:scraped_values, scrape) { @job_listing.scrape_attributes }

    assert_equal scrape.url, @job_listing.url
    assert_equal scrape.html, @job_listing.raw_scraping_data
    assert_equal scrape.company, @job_listing.company
    assert_equal scrape.description, @job_listing.description
    assert_equal scrape.apply_details, @job_listing.apply_details
    assert_equal scrape.apply_link, @job_listing.apply_link
    assert_equal scrape.position, @job_listing.position
    assert_equal scrape.posted_date, @job_listing.posted_date
    assert_equal scrape.company_website, @job_listing.company_website
  end

  test "scrape_attributes should not set attributes if no adapter found" do
    @job_listing.url = 'http://www.noadapterfound.com/test'
    @job_listing.scrape_attributes

    assert_equal 'http://www.noadapterfound.com/test', @job_listing.url
    assert_equal nil, @job_listing.raw_scraping_data
    assert_equal nil, @job_listing.company
    assert_equal nil, @job_listing.description
    assert_equal nil, @job_listing.apply_details
    assert_equal nil, @job_listing.apply_link
    assert_equal nil, @job_listing.position
    assert_equal nil, @job_listing.posted_date
    assert_equal nil, @job_listing.company_website
  end
end
