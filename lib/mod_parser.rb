require 'google_drive'

class ModParser

  attr_accessor :sheet, :mods

  def initialize
    session = GoogleDrive.login("niuage2@gmail.com", "idontcare25")
    @sheet = session.spreadsheet_by_key("0ArsB7KohOhhpdHoyZzU2WVZZNXQxMDg4MVk1b0FGbkE").worksheets[1]
    @types = type_mapping
    @mods = {}
  end

  def parse
    for row in 1..@sheet.num_rows
      add_mod(row)
    end

    mods.each { |mod, types| mods[mod].uniq! }
  end

  def add_mod(row)
    mod = sheet[row, 2]
    mods[mod] = [] if mods[mod].nil?
    for i in 0..17
      mods[mod] << type_mapping[i] if sheet[row, i + 8].match("Yes")
    end
  end

  def type_mapping
    [
      "ring",
      "amulet",
      "belt",
      "helmet",
      "glove",
      "boots",
      "body_armour",
      "shield",
      "quiver",
      "wand",
      "dagger",
      "claw",
      "sceptre",
      "staff",
      "bow",
      "sword",
      "axe",
      "mace"
    ]
  end

end
