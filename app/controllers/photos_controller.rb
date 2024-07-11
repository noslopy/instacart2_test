# frozen_string_literal: true

class PhotosController < ApplicationController
  def show
    photos = Photo.select(:caption, :id).map {|photo| photo_filter(photo)}
    render json: photos, status: :ok
  end

  def create
    errors = []
    errors << 'Image can\'t be blank' unless params[:photo][:image].present?
    errors << 'Caption can\'t be blank' unless params[:photo][:caption].present?
    errors << 'Caption can\'t be more then 100 characters' unless params[:photo][:caption].length <= 100
    
    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity
      return
    end

    photo = Photo.new
    photo.caption = params[:photo][:caption]
    # upload = MiniMagick::Image.new(params[:photo][:image].tempfile.path)
    # upload.resize '300x300'
    # photo.image.attach io: StringIO.open(upload.to_blob), filename: params[:photo][:image]
    photo.image.attach params[:photo][:image]

    begin
      photo.save!
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors[:image] }, status: :unprocessable_entity
      return
    end
    photo.image.blob.update(filename: "#{photo.id}.#{photo.image.blob.filename.extension}")
    render json: photo_filter(photo), status: :created
  end

  private

  def photo_filter photo
    { caption: photo.caption, id: photo.id, image: photo.image.blob.filename }
  end
end
