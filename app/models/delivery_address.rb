class DeliveryAddress < ApplicationRecord
  PHONE_VALID_REGEX = /\A\d+(\s\d+)*\z/i.freeze

  belongs_to :user
  validates :name, length: {maximum: Settings.user.name_max_len}
  validates :phone, format: {with: PHONE_VALID_REGEX},
                    length: {maximum: Settings.user.phone_max_len}
end
