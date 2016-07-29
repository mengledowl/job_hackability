require 'httparty'
require 'nokogiri'

class Scraper
  attr_accessor :url, :html, :company, :description, :apply_details, :apply_link, :position, :posted_date, :company_website

  def initialize(url)
    @url = url
  end

  # we work remotely
  def scrape
    page = HTTParty.get(url)

    self.html = Nokogiri::HTML(page)

    self.position = html.css('.listing-header-container').css('h1').inner_html
    self.posted_date = Date.parse(html.css('.listing-header-container').css('h3').inner_html)
    self.company = html.css('.company').inner_html
    self.company_website = html.css('.listing-header-container').css('a').first['href']
    self.description = html.css('.listing-container').inner_html.gsub(/\s{2,}|\n/, '')
    self.apply_link = html.css('.apply').css('a').inner_html
    self.apply_details = html.css('.apply p').inner_html

    self
  end
end