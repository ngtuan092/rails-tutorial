class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :content, presence: true,
    length: {maximum: Settings.validate.content.length.max}

  validates :image, content_type: {in: Settings.validate.im.type,
                                   message: I18n.t("microposts_image_type")},
                    size: {less_than: Settings.validate.im.size.megabytes,
                           message: I18n.t("microposts_image_size")}

  scope :newest, ->{order created_at: :desc}

  delegate :name, to: :user, prefix: true

  def display_image
    image.variant resize_to_limit: [Settings.validate.im.size,
                                    Settings.validate.im.size]
  end
end
