require 'test_helper'

class StackOverflowTest < ActiveSupport::TestCase
  def setup
    @url = 'http://www.stackoverflow.com/test'
    @html = File.read('test/files/stackoverflow_example.html')
    HTTParty.stub :get, @html do
      @scraped_hash = Scraper::StackOverflow.new(@url).scrape
    end
  end

  test "should correctly set the url" do
    assert_equal @url, @scraped_hash.url
  end

  test "should correctly set position" do
    assert_equal 'Software Engineer', @scraped_hash.position
  end

  test "should not set the posted_date" do
    assert_equal nil, @scraped_hash.posted_date
  end

  test "should set the company" do
    assert_equal 'Samasource', @scraped_hash.company
  end

  test "should not set the company website" do
    assert_equal nil, @scraped_hash.company_website
  end

  test "should set the description" do
    assert_equal "<h2 class=\"detail-sectionTitle\">Job Description</h2><div><p>Samasource provides sustainable pathways out of poverty to underprivileged youth throughout Africa and Asia. We're an award-winning nonprofit that works with major Silicon Valley companies to provide dignified online work across Kenya, Uganda, Ghana, Haiti and India.</p><p>As our newest software engineer, you'll help develop &amp; maintain our online platform, which receives over 2 million work submissions each month. You'll work with a team of engineers spread across the US and liaise with technical staff in Kenya and India.</p><p>We write test-driven, continuously integrated, peer-reviewed Ruby/Rails/AngularJS code. We're vigilant about staying up to date with latest releases of all our frameworks &amp; tools. We run our platform on Heroku, store code in GitHub, continuously integrate with CircleCI, monitor with NewRelic, and use PivotalTracker to keep our agile workflow flowing.</p></div><ul><li>A degree in Software Engineering/CS, or 3+ years back-end development experience</li><li>1 year test-driven Ruby/Rails development experience</li><li>1 year JavaScript/jQuery experience</li><li>1 year SQL (Postgres preferred) database experience</li><li>Familiarity &amp; comfort with OSX/Linux development environments</li><li>Comfort in both remote-paired and solo work environments</li><li>Strong written &amp; verbal English communication skills</li><li>An interest in helping underprivileged youth to find avenues out of poverty</li></ul>",
                 @scraped_hash.description
  end

  test "should not set the apply_link" do
    assert_equal nil, @scraped_hash.apply_link
  end

  test "should not set apply_details" do
    assert_equal nil, @scraped_hash.apply_details
  end
end