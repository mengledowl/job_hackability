module ApplicationHelper
  def full_title(page_title)
    base_title = "Job Hackability"
    unless page_title.empty?; return "#{base_title} | #{page_title}"; end
    base_title
  end
end
