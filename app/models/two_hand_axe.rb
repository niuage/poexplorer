class TwoHandAxe < Weapon
  include ItemExtensions::Mapping
  BASE_NAMES = G_BASE_NAMES['weapon']['two_hand_axe']

  document_type 'item'
  index_name { TireIndex.name(Thread.current[:current_league_id]) }
end
