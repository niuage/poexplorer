class Exile < ActiveRecord::Base
  include ExileExtensions::Mapping

  GEAR_TYPES = [:helmet, :main_weapon, :offhand_weapon, :body_armour, :gloves, :belt, :boots]

  belongs_to :user
  belongs_to :klass

  has_many :exile_uniques
  has_many :uniques, through: :exile_uniques

  store :cached_photos, accessors: [:photos, :cover], coder: JSON
  store :items, accessors: [GEAR_TYPES], coder: JSON

  attr_accessible :name, :tagline, :description, :album_uid, :video_uid,
    :klass_id, :unique_ids,
    :helmet, :main_weapon, :offhand_weapon, :body_armour, :gloves, :belt, :boots

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
  validates :tagline, length: { maximum: 128 }
  validates :description, length: { maximum: 3000 }

  delegate :login, to: :user, prefix: true
  delegate :name, to: :klass, prefix: true

  make_voteable

  def to_params
    "#{id}-#{name.parameterize}"
  end

  def cover(size = nil)
    c = cached_photos["cover"]
    return c if size.blank? || c.blank?
    resized_photo(c, size)
  end
  def large_cover; cover(:l) end

  def photos(size = nil)
    return cached_photos["photos"] if size.blank?
    cached_photos["photos"].map do |photo|
      resized_photo(photo, size)
    end
  end

  def resized_photo(photo, size)
    parts = photo.split(".")
    parts[-2] << size.to_s
    parts.join(".")
  end

  def gear
    GEAR_TYPES.map do |type|
      next unless (name = send(type)).present?
      { type: type.to_s.titleize, name: name }
    end.compact
  end

  def any_photos?
    photos && photos.any?
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
