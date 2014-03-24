class TwoHandMace < Weapon
  include ItemExtensions::Mapping
  BASE_NAMES = G_BASE_NAMES['weapon']['two_hand_mace']

  document_type 'item'
  index_name { TireIndex.name(Thread.current[:current_league_id]) }
end
