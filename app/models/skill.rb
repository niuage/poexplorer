class Skill < Misc
  include ItemExtensions::Mapping
  BASE_NAMES = G_BASE_NAMES['misc']['skill']

  document_type 'item'
  index_name { TireIndex.name(Thread.current[:current_league_id]) }

  def skill?; true end
end
