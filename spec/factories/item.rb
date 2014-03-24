FactoryGirl.define do
  factory :item do
    name ""
  end

  factory :indexed_item, parent: :item do
    indexed_at Time.zone.now
  end

  factory :indexed_item_with_sockets, parent: :indexed_item do
    sockets [
      { "group" => "0", "attr" => "D" },
      { "group" => "1", "attr" => "S" },
      { "group" => "2", "attr" => "I" }
    ]
  end

  factory :indexed_weapon_with_sockets, parent: :indexed_item do
    sockets [
      { "group" => "0", "attr" => "D" },
      { "group" => "1", "attr" => "S" },
      { "group" => "2", "attr" => "I" }
    ]
    type "Bow"
  end

end
