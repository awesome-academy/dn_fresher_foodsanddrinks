class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process resize_to_limit: [Settings.uploaders.image.size,
                            Settings.uploaders.image.size]

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url *_args
    "/assets/" + [version_name, "default.jpg"].compact.join("_")
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
