module BuildExtensions
  module Constants

    LIFE_TYPES = {
      "Life" => 1,
      "CI" => 2,
      "Low Life" => 3,
      "Hybrid" => 4
    }

    def life_type_label
      LIFE_TYPES.find { |k, v| v == life_type }.try(:[], 0)
    end

    PLAYSTYLES = {
      "2h Melee" => 1,
      "1h + Shield" => 2,
      "Dual wield" => 3,
      "Ranged" => 4,
      "Spellcaster" => 5,
      "Totemer" => 6,
      "Summoner" => 7,
      "Trapper" => 8,
      "Miner" => 9
    }

    ROLES = {
      "Balanced" => 1,
      "Support" => 2,
      "Tank" => 3,
      "MF" => 4,
      "Glass cannon" => 5
    }

  end
end
