class Scraper::WeWorkRemotely < Scraper
  def scrape
    self.position = html.css('.listing-header-container h1').inner_html
    self.posted_date = Date.parse(html.css('.listing-header-container h3').inner_html)
    self.company = html.css('.company').inner_html
    self.company_website = html.css('.listing-header-container a').first['href']
    self.description = html.css('.listing-container').inner_html.gsub(/\s{2,}|\n/, '')
    self.apply_link = html.css('.apply a').inner_html
    self.apply_details = html.css('.apply p').inner_html

    OpenStruct.new(attributes)
  end
end