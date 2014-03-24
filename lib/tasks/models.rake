namespace :models do
  task :models => :environment do
    G_BASE_NAMES.each_pair do |category, types|
      types.each_pair do |type, values|
        file = File.join(Rails.root, "app", "models", "#{type}.rb")
        fid = File.open(file, "w")
        fid.write("class #{type.classify} < #{category.classify}\n")
        fid.write("  include ItemExtensions::Mapping\n")
        fid.write("  BASE_NAMES = G_BASE_NAMES['#{category}']['#{type}']\n")
        fid.write("  \n")
        fid.write("  document_type 'item'\n")
        fid.write("  index_name { TireIndex.name(Thread.current[:current_league_id]) }\n")
        fid.write("  def skill?; true end") if type.to_s == "skill"
        fid.write("  def map?; true end") if type.to_s == "map"
        fid.write("end\n")
      end
    end
  end

  task :nested_models => :environment do
    G_BASE_NAMES.each_pair do |category, types|
      types.each_pair do |type, values|
        file = File.join(Rails.root, "app", "models", "items", "#{type}.rb")
        fid = File.open(file, "w")
        fid.write("module Items")
        fid.write("  class #{type.classify} < ::#{category.classify}\n")
        fid.write("    include ItemExtensions::Mapping\n")
        fid.write("    BASE_NAMES = G_BASE_NAMES['#{category}']['#{type}']\n")
        fid.write("  end\n")
        fid.write("end\n")
      end
    end
  end

  task :remove_root_items => :environment do
    G_BASE_NAMES.each_pair do |category, types|
      types.each_pair do |type, values|
        begin
          File.delete(File.join(Rails.root, "app", "models", "#{type}.rb"))
        rescue
        end
      end
    end
  end
end
