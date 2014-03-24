class Map < Misc
  include ItemExtensions::Mapping
  BASE_NAMES = G_BASE_NAMES['misc']['map']

  document_type 'item'
  index_name { TireIndex.name(Thread.current[:current_league_id]) }

  def map?; true end
end
