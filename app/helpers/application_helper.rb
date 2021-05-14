module ApplicationHelper
  def full_title page_title = ""
    base_title = "Rails eCommerce"
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def check_logged_in
    return if is_logged_in?

    flash[:warning] = t :have_to_login
    redirect_to root_path
  end
end
