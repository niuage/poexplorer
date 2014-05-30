class Misc < Item
  TYPES = G_MISC_TYPES.freeze
  BASE_NAMES = G_MISC_BASE_NAMES.freeze

  def misc?; true end

  def has_sockets?; false end
end
