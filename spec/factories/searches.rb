FactoryGirl.define do

  factory :search do
    association :item
  end

  factory :weapon_search, parent: :search do

  end

end
