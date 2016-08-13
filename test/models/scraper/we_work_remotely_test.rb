require 'test_helper'

class WeWorkRemotelyTest < ActiveSupport::TestCase
  def setup
    @url = 'http://www.weworkremotely.com/test'
    @html = File.read('test/files/we_work_remotely_example.html')
    HTTParty.stub :get, @html do
      @scraped_hash = Scraper::WeWorkRemotely.new(@url).scrape
    end
  end

  test "should correctly set the url" do
    assert_equal @url, @scraped_hash.url
  end

  test "should correctly set position" do
    assert_equal 'Rails Developer', @scraped_hash.position
  end

  test "should correcty set posted_date" do
    assert_equal Date.parse('Jul 28'), @scraped_hash.posted_date
  end

  test "should correctly set company" do
    assert_equal 'GotSoccer, LLC', @scraped_hash.company
  end

  test "should correctly set company_website" do
    assert_equal 'https://www.gotsoccer.com', @scraped_hash.company_website
  end

  test "should correctly set description" do
    assert_equal "<div>GotSoccer is looking for a full time Rails developer to help build and maintain our web applications supporting both youth and professional soccer leagues around the world. </div><div class=\"paragraph_break\"><br></div><div>You’ll actively participate in the development and maintenance of our software and will have lots of autonomy conceptualizing, building, and testing new features. </div><div class=\"paragraph_break\"><br></div><div>You should be comfortable working on both the back-end and front-end of large web apps, have an eye for good UI/UX, and have experience collaborating with teammates, project managers, and project stakeholders to define, schedule, and shape a product’s roadmap. </div><div class=\"paragraph_break\"><br></div><div>The ideal candidate will have 1-2 years experience working with production Ruby on Rails applications and is comfortable using some or all of the following:</div><div class=\"paragraph_break\"><br></div><ul><li>Ruby on Rails</li><li>MongoDB</li><li>PostgreSQL</li><li>Javascript/jQuery</li><li>RSpec</li><li>Bootstrap</li><li>HAML</li><li>Coffeescript</li><li>Git </li></ul><div class=\"paragraph_break\"><br></div><div>US based candidates are preferred. You will be working as an independent contractor for 3 months, after which a salaried position is available. </div><div class=\"paragraph_break\"><br></div>",
                 @scraped_hash.description.gsub(/\t/, '')
  end

  test "should correctly set apply_link" do
    assert_equal 'mailto:jobs@gotsoccer.com', @scraped_hash.apply_link
  end

  test "should correctly set apply details" do
    assert_equal "Send your resume with references to <a href=\"mailto:%6a%6f%62%73@%67%6f%74%73%6f%63%63%65%72.%63%6f%6d\">jobs@gotsoccer.com</a>",
                 @scraped_hash.apply_details
  end

  test "should set remote to true" do
    assert @scraped_hash.remote
  end

  test "should set location" do
    assert_equal 'Headquarters: Neptune Beach, FL', @scraped_hash.location
  end
end