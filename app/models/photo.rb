class Photo < ApplicationRecord
  has_one_attached :image

  validates :caption, :presence => true
  validates :image, attached: true,
              content_type: {in: ['jpg', 'png'], message: 'Uploaded image is neither a JPG nor PNG image'},
              size: { less_than: 200.kilobytes , message: 'File too large. Maximum limit of 200KB exceeded' }
end
