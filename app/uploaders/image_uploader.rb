class ImageUploader < Shrine
  ALLOWED_TYPES = %w[image/jpeg image/jpg image/png image/gif]

  plugin :validation_helpers
  plugin :store_dimensions
  plugin :default_url

  Attacher.validate do
    validate_mime_type ALLOWED_TYPES
  end

  Attacher.default_url do |**options|
    "/assets/images/no_image.png"
  end
end
