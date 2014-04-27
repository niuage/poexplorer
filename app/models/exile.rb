class Exile < ActiveRecord::Base
  belongs_to :user
  belongs_to :klass

  store :cached_photos, accessors: [:photos, :cover], coder: JSON

  attr_accessible :name, :tagline, :description, :album_uid, :video_uid, :klass_id

  before_validation :set_album_uid, if: :album_uid_changed?

  before_save :cache_photos #, if: :album_uid_changed?

  class ImgurAlbumValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if value.present? && !value.match(/[A-Za-z0-9]+/)
        record.errors[attribute] << "The Imgur album is invalid"
      end
    end
  end
  validates :album_uid, presence: true, imgur_album: true
  validates :name, presence: true
  validates :klass, presence: true

  def to_params
    "#{id}-#{name.parameterize}"
  end

  def cover(size = "")
    return cached_photos["cover"] if size.blank?
    parts = cached_photos["cover"].split(".")
    parts[-2] << size.to_s
    parts.join(".")
  end

  private

  def set_album_uid
    return unless album_uid.present?

    uid = album_uid.split("/").last.match(/([A-Za-z0-9]+)/).try :[], 0
    return unless uid

    write_attribute(:album_uid, uid)
  end

  def cache_photos
    if album = Imgur::Album.find_by_id(album_uid)
      self.photos = album.image_links
      self.cover = album.cover_link
    end
  end
end
