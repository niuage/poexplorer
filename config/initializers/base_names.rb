G_BASE_NAMES = YAML.load_file(File.join(Rails.root, "config", "base_names.yml"))

G_WEAPON_TYPES = G_BASE_NAMES["weapon"].keys.map(&:classify)
G_ARMOUR_TYPES = G_BASE_NAMES["armour"].keys.map(&:classify)
G_MISC_TYPES = G_BASE_NAMES["misc"].keys.map(&:classify)
G_INDEX_TYPES = [G_WEAPON_TYPES, G_ARMOUR_TYPES, G_MISC_TYPES].flatten

G_GEAR_TYPES = [G_WEAPON_TYPES, G_ARMOUR_TYPES].flatten.map &:titleize

G_WEAPON_BASE_NAMES = G_BASE_NAMES["weapon"].values.flatten
G_ARMOUR_BASE_NAMES = G_BASE_NAMES["armour"].values.flatten
G_MISC_BASE_NAMES = G_BASE_NAMES["misc"].values.flatten
