class Photo < ApplicationRecord
  has_one_attached :image do |img|
    img.variant :sm, resize_to_fill: [300, 300]
  end
  validates :caption, :presence => true
  validates :image, attached: true,
              content_type: {in: ['jpg', 'png'], message: 'Uploaded image is neither a JPG nor PNG image'},
              size: { less_than: 200.kilobytes , message: 'File too large. Maximum limit of 200KB exceeded' }
  
  after_save {
    finalize_attachment
  }

  private
  def finalize_attachment
    image.variant(:sm).blob.update(filename: "#{id}.#{image.blob.filename.extension}")
  end
end
