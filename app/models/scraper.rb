require 'httparty'
require 'nokogiri'

class Scraper
  attr_accessor :url, :html, :company, :description, :apply_details, :apply_link, :position, :posted_date, :company_website, :remote, :location

  def initialize(url)
    set_url(url)
  end

  def html
    @html ||= scrape_html
  end

  def self.adapter(url)
    host = URI(format_and_validate_url(url)).hostname

    scraper_adapter = nil

    adapter_list.each do |item|
      if host.match(item.gsub('_', ''))
        scraper_adapter = item
        break
      end
    end

    if scraper_adapter
      scraper_adapter = "Scraper::#{scraper_adapter.camelize}".constantize
    else
      raise NoAdapterFoundError, "Missing scraper for #{host}"
    end

    scraper_adapter
  end

  def self.adapter_list
    list = Dir["app/models/scraper/*.rb"]
    list.each { |item| item.gsub!(/app\/models\/scraper\/|\.rb/, '') }
    list
  end

  def format_apply_link(apply_link)
    return apply_link unless apply_link.present?

    if apply_link.match(/\w+@\w+\.\w+/)
      apply_link.starts_with?('mailto:') ? apply_link : "mailto:#{apply_link}"
    else
      apply_link
    end
  end

  def attributes
    {
        url: url,
        html: html,
        company: company,
        description: description,
        apply_details: apply_details,
        apply_link: format_apply_link(apply_link),
        position: position,
        posted_date: posted_date,
        company_website: company_website,
        remote: remote,
        location: location
    }
  end

  def self.format_and_validate_url(url)
    url = url.starts_with?('http://', 'https://') ? url : "http://#{url}"
    raise ArgumentError, 'Invalid URL' unless url =~ /https?:\/\/\w+\.\w+/
    url
  end

  private

  def set_url(url)
    @url = Scraper.format_and_validate_url(url)
  end

  def scrape_html
    page = HTTParty.get(url)

    self.html = Nokogiri::HTML(page)
  end
end