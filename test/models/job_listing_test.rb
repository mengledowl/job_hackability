require 'test_helper'
require 'yaml'

class JobListingTest < ActiveSupport::TestCase
  def setup
    @job_listing = JobListing.new
    @scraper_attributes = YAML.load(ERB.new(File.read('test/files/scraper.yml')).result)['we_work_remotely']
  end

  test "should have unique urls per user" do
    @job_listing.url = 'sampleurl.com' # duplicate
    @job_listing.user = users(:one)

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
    assert_equal scrape.remote, @job_listing.remote
    assert_equal scrape.location, @job_listing.location
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
    assert_equal nil, @job_listing.remote
    assert_equal nil, @job_listing.location
  end

  test "scrape_attributes should not set any attributes already set" do
    @job_listing.company = 'Test Company'
    @job_listing.description = 'Test description'
    @job_listing.apply_details = 'Test apply_details'
    @job_listing.apply_link = 'Test apply_link'
    @job_listing.position = 'Test position'
    @job_listing.posted_date = 2.days.ago.to_date
    @job_listing.company_website = 'Test company_website'
    @job_listing.url = @scraper_attributes['url']
    scrape = Scraper.new(@scraper_attributes['url'])

    @scraper_attributes.each { |k,v| scrape.send("#{k}=", v) }

    @job_listing.stub(:scraped_values, scrape) { @job_listing.scrape_attributes }

    assert_equal scrape.url, @job_listing.url
    assert_equal scrape.html, @job_listing.raw_scraping_data
    assert_equal 'Test Company', @job_listing.company
    assert_equal 'Test description', @job_listing.description
    assert_equal 'Test apply_details', @job_listing.apply_details
    assert_equal 'Test apply_link', @job_listing.apply_link
    assert_equal 'Test position', @job_listing.position
    assert_equal 2.days.ago.to_date, @job_listing.posted_date
    assert_equal 'Test company_website', @job_listing.company_website
  end

  test "scrape_attributes should set attributes already set when force: true included" do
    @job_listing.company = 'Test Company'
    @job_listing.description = 'Test description'
    @job_listing.apply_details = 'Test apply_details'
    @job_listing.apply_link = 'Test apply_link'
    @job_listing.position = 'Test position'
    @job_listing.posted_date = 2.days.ago.to_date
    @job_listing.company_website = 'Test company_website'
    @job_listing.url = @scraper_attributes['url']
    scrape = Scraper.new(@scraper_attributes['url'])

    @scraper_attributes.each { |k,v| scrape.send("#{k}=", v) }

    @job_listing.stub(:scraped_values, scrape) { @job_listing.scrape_attributes(force: true) }

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

  test "display_name should return title if available" do
    @job_listing.title = 'title test'

    assert_equal 'title test', @job_listing.display_name
  end

  test "display_name should return {position} at {company} if title nil and position and company present" do
    @job_listing.title = ''
    @job_listing.position = 'position test'
    @job_listing.company = 'company test'

    assert_equal 'position test at company test', @job_listing.display_name
  end

  test "display_name should return url if title and position_at_company empty" do
    @job_listing.title = ''
    @job_listing.position = ''
    @job_listing.company = ''
    @job_listing.url = 'http://www.test.com/test'

    assert_equal 'http://www.test.com/test', @job_listing.display_name
  end

  test "status should only allow no_interview_granted, interviewing, offer_received, offer_declined, and no_offer_given" do
    @job_listing.url = 'http://www.test.com/test'

    JobListing::STATUS_VALUES.each do |status|
      @job_listing.status = status

      assert @job_listing.valid?
    end

    @job_listing.status = :not_allowed

    assert_not @job_listing.valid?
  end

  test "status should allow nil" do
    @job_listing.url = 'http://www.test.com/test'

    assert @job_listing.valid?
  end

  test "adding first interview should automatically set status to interviewing" do
    @job_listing.url = 'http://www.test.com/test'
    @job_listing.save

    @job_listing.interviews << Interview.new

    assert_equal 'interviewing', @job_listing.status
  end

  test "adding later interviews should not change status" do
    @job_listing.url = 'http://www.test.com/test'
    @job_listing.save

    @job_listing.interviews << Interview.new

    @job_listing.update(status: :offer_received)
    @job_listing.interviews << Interview.new

    assert_equal 'offer_received', @job_listing.status
  end
end
