module ApplicationHelper
  def full_title page_title = ""
    base_title = "Rails eCommerce"
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
