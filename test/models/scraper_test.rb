require 'test_helper'
require 'httparty'

class ScraperTest < ActiveSupport::TestCase
  def setup
    @url = 'http://www.weworkremotely.com/test'
  end

  test "should return the adapter correctly" do
    assert_equal Scraper::WeWorkRemotely, Scraper.adapter(@url)
  end

  test "should raise NoAdapterFound if no adapter found" do
    assert_raises(NoAdapterFoundError) { Scraper.adapter('http://www.noadapterfound.com/test') }
  end
end