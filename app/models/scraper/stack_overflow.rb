class Scraper::StackOverflow < Scraper
  def scrape
    self.position = html.css('a.title.job-link').first.inner_html
    self.company = html.css('a.employer').first.inner_html
    self.description = html.css('.description').inner_html.gsub(/\s{2,}|\n/, '')
    self.apply_link = html.css('a#apply').first['href']
    self.location = html.css('li.location').first.inner_html.strip
    self.remote = (html.css('li.detail-remote').first.inner_html.strip == 'Remote')

    OpenStruct.new(attributes)
  end
end