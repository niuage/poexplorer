class BanditChoice < ActiveRecord::Base
  belongs_to :build

  attr_accessible :normal_choice, :cruel_choice, :merciless_choice, :alternatives

  DIFFICULTY = [:normal, :cruel, :merciless]

  DEFAULT_CHOICE = 4

  CHOICES = {
    normal: [
      ["Help Alira (+40 base mana)", 1],
      ["Help Kraityn (+8% all elemental resistances)", 2],
      ["Help Oak (+40 base life)", 3],
      ["Kill All (1 passive skill point)", 4]
    ],
    cruel: [
      ["Help Alira (+4% cast speed)", 1],
      ["Help Kraityn (+8% attack speed)", 2],
      ["Help Oak (+18% physical damage)", 3],
      ["Kill All (1 passive skill point)", 4]
    ],
    merciless: [
      ["Help Alira (+1 max power charge)", 1],
      ["Help Kraityn (+1 max frenzy charge)", 2],
      ["Help Oak (+1 max endurance charge)", 3],
      ["Kill All (1 passive skill point)", 4]
    ]
  }

  def self.difficulty
    DIFFICULTY
  end

  def self.choices(difficulty)
    CHOICES[difficulty]
  end

  def default_choice(difficulty)
    CHOICES[difficulty].last[1]
  end

  def choice(difficulty)
    send(:"#{difficulty}_choice") || default_choice(difficulty)
  end

  def to_s(difficulty)
    CHOICES[difficulty].find { |k, v| v == choice(difficulty) }[0]
  end
end
