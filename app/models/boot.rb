class Boot < Armour
  include ItemExtensions::Mapping
  BASE_NAMES = G_BASE_NAMES['armour']['boot']

  document_type 'item'
  index_name { TireIndex.name(Thread.current[:current_league_id]) }
end
