namespace :datafix do

  # FAIRE GAFFE A PAS CREER PLUSIEURS FOIS CES CUSTOMS MODS
  # update items iwth custom mods
  task :custom_mods => :environment do
    implicit_modifiers_ids = G_IMPLICIT_MODIFIERS.map do |key, value|
      Mod.find_by_name(key).id
    end
    custom_ids = G_CUSTOM_MODIFIERS.map do |mod|
      Mod.find_by_name(mod).id
    end

    # raise custom_ids.inspect

    Item.find_each do |item|
      if item.skill?
        (puts "SKILL")
        next
      end
      stats = item.stats
      stat_count = stats.count
      has_custom_mods = (stats.hidden.map(&:mod_id) & custom_ids).any?
      if has_custom_mods
        (puts "HAS CUSTOM MODS")
        next
      end
      if ((lala = stats.hidden.pluck(:mod_id)) & implicit_modifiers_ids).any?
        puts "HAS HIDDEN IMPLICIT MODS #{lala}"
        next
      end

      builder = StatBuilder.new(item)

      stats.visible.each do |stat|
        builder.update_custom_stats(stat)
      end

      mod = stats.first.try :mod
      if mod.try(:implicit?)
        mod.value = stats.first.value
        builder.implicit_mod = mod
      end

      builder.save_custom_stats

      item.save
      end_stat_count = item.stats.count
      puts "#{item.id} ---- #{stat_count} - #{end_stat_count}" if end_stat_count != stat_count
      puts "-----"
    end
  end

  task :repair_mod_name => :environment do
    Mod.find_by(name: "#% of Physical Attack Damage Leeched back as Mana").update_attribute(
      :name, "#% of Physical Attack Damage Leeched as Mana"
    )

    Mod.find_by(name: "#% of Physical Attack Damage Leeched back as Life").update_attribute(
      :name, "#% of Physical Attack Damage Leeched as Life"
    )
  end

  # crappy code is crappy, who the fuck cares?
  task :import_uniques => :environment do
    uniques = []

    doc = Nokogiri::HTML(open("http://pathofexile.gamepedia.com/Full_Unique_Index"))
    trs = doc.css(".wikitable").css("tr")

    trs.each do |tr|
      unique = {}
      tr.css("td").each_with_index do |td, i|
        case i
        when 0
          td.css("a").each_with_index do |a, i|
            if i == 0
              unique[:name] = a.content
            end
            if i == 1
              unique[:img] = a.css("img").first().attr("src")
            end
          end
        when 1
          unique[:base_name] = td.css("a").first.content
        end

        break if i > 1
      end

      uniques << unique
    end

    uniques.delete_if { |unique| unique.empty? }

    uniques.each do |unique|
      u = Unique.where(name: unique[:name]).first_or_initialize
      u.image_url = unique[:img]
      u.base_item = unique[:base_name]
      u.save
    end
  end

  task :import_gems => :environment do
    skills = []
    attributes = ["str", "dex", "int"]

    doc = Nokogiri::HTML(open("http://pathofexile.gamepedia.com/Skills"))
    trs = doc.css(".wikitable").last().css("tr")

    trs.each do |tr|
      skill = {}

      tr.css("td").each_with_index do |td, i|
        next if i > 0

        span = td.css("span")
        klass = span.first.attr("class")
        skill[:attr] = klass.split(" ")[1].gsub("-skill", "")
        skill[:support] = !!skill[:attr].match("suppt")
        skill[:attr] = skill[:attr].gsub("-suppt", "")
        skill[:name] = span.css("a").first().content
      end

      skills << skill
    end

    skills.delete_if { |s| s.empty? }

    skills.concat [
      {
        name: "Increased Burning Damage",
        attr: "str",
        support: true
      }, {
        name: "Multiple Traps",
        attr: "dex",
        support: true
      }
    ]

    skills.each do |skill|
      s = SkillGem.where(name: skill[:name]).first_or_initialize
      s.attr = skill[:attr]
      s.support = skill[:support]
      s.save
    end
  end

  task :import_nodes => :environment do

    nodes = JSON.parse(IO.read('nodes.txt'))["nodes"]

    names = {}
    nodes.each do |node|
      if names.has_key?(node["dn"])
        names[node["dn"]] += 1
      else
        names[node["dn"]] = 0
      end
    end
    puts names.sort { |a, b| a[1] <=> b[1] }.reverse
    puts names.size
  end

end
