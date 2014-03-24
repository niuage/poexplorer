# encoding: utf-8

class AvatarUploader < BaseUploader

  process :resize_to_fit => [170, 250]

  version :thumb do
    process :resize_to_fill => [50, 50]
  end

  version :square do
    process :resize_to_fill => [70, 70]
  end

end
