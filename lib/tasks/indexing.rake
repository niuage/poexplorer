namespace :index do
  task :clean_up => :environment do |t, args|
    Item::TYPES.each do |type|
      Tire.index(type.underscore.pluralize).delete
    end
    Tire.index("players").delete
  end

  task :index, [:prefix] => :environment do |t, args|
    League.running.each do |league|
      lid = league.id
      index_name = "poe_#{args[:prefix]}_#{lid}"
      index = Tire.index(index_name)
      index.create(mappings: mappings, settings: {})
      # Tire::Tasks::Import.create_index(index, Item::TYPES.first.constantize)

      a = Tire::Alias.new
      a.index index_name
      a.name TireIndex.name(lid)
      a.save
    end

    League.running.each do |league|
      # include: [:stats] is not supported anymore :(
      league.items.find_in_batches() do |batch|
        index_name = "poe_#{args[:prefix]}_#{league.id}"
        Tire.index(index_name).import batch, _routing: :user
        puts "Importerd 1000 items"
      end

      league.players.find_in_batches do |batch|
        index_name = "poe_#{args[:prefix]}_#{league.id}"
        Tire.index(index_name).import batch
        puts "Imported 1000 players in #{index_name}"
      end
    end
  end

  def mappings
    Item::TYPES.first.constantize.tire.mapping_to_hash.merge \
      Player.tire.mapping_to_hash
  end

  task :reindex, [:prefix, :env] => :environment do |t, args|
    League.running.each do |league|
      lid = league.id
      index_name = "poe_#{args[:prefix]}_#{lid}"
      index = Tire.index(index_name)
      index.create(mappings: mappings, settings: {})
      # Tire::Tasks::Import.create_index(index, )
    end

    League.running.each do |league|
      # include: [:stats] not support in rails 4
      league.items.find_in_batches() do |batch|
        index_name = "poe_#{args[:prefix]}_#{league.id}"
        Tire.index(index_name).import batch, _routing: :user
        puts "Imported 1000 items in #{index_name}"
      end

      league.players.find_in_batches do |batch|
        index_name = "poe_#{args[:prefix]}_#{league.id}"
        Tire.index(index_name).import batch
        puts "Imported 1000 players in #{index_name}"
      end
    end
  end

  task :update_aliases, [:new_index_prefix] => :environment do |t, args|
    League.running.each do |league|
      lid = league.id
      a = TireIndex.alias(lid)
      a.index.each { |i| a.index.delete(i); a.save }
      a.save
      a.index "poe_#{args[:new_index_prefix]}_#{lid}"
      a.name TireIndex.name(lid)
      a.save
      puts a.index.map { |s| s }.inspect
    end
  end

  task :delete_indexes, [:prefix] => :environment do |t, args|
    League.running.each do |league|
      lid = league.id
      if a = Tire::Alias.find(TireIndex.name(lid))
        a.index.each do |index_name|
          if index_name.match "poe_#{args[:prefix]}_"
            puts "ABORTED #{args[:prefix]} #{lid}"
            # next
          end
        end
      end

      Tire.index("poe_#{args[:prefix]}_#{lid}").delete
    end
  end

  task :reset_all_the_things => :environment do
    `rake db:drop db:create db:migrate db:seed;`
    `curl -XDELETE 'http://localhost:9200/_all'`
    `bundle exec rake 'index:index[lala]'`
  end

end
