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

  test "format_apply_link should work with nil" do
    scraper = Scraper.new('http://www.test.com/test')

    assert_equal nil, scraper.format_apply_link(nil)
  end

  test "format_apply_link should return normal urls correctly" do
    scraper = Scraper.new('http://www.test.com/test')
    url = 'http://www.test.com/test'

    assert_equal url, scraper.format_apply_link(url)
  end

  test "format_apply_link should return emails as a mailto" do
    scraper = Scraper.new('http://www.test.com/test')
    url = 'jobs@company.com'

    assert_equal "mailto:#{url}", scraper.format_apply_link(url)
  end

  test "format_apply_link should correctly handle mailto already being part of the string" do
    scraper = Scraper.new('http://www.test.com/test')
    url = 'mailto:jobs@company.com'

    assert_equal url, scraper.format_apply_link(url)
  end

  test "should add http:// to url when not detected" do
    url = 'test.com'
    scraper = Scraper.new(url)

    assert_equal "http://#{url}", scraper.url
  end

  test "should raise error if url not valid" do
    url = 'test'
    assert_raises(ArgumentError) { Scraper.new(url) }
  end
end