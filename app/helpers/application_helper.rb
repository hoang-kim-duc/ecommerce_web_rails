module ApplicationHelper
  FLASH_MAP = {notice: :info, alert: :warning}.freeze

  def full_title page_title = ""
    base_title = "Rails eCommerce"
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def mapping_alert_type flash_key
    return FLASH_MAP[flash_key.to_sym] if FLASH_MAP[flash_key.to_sym]

    flash_key
  end
end
