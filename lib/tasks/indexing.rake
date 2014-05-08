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

      TireIndex.create_index(args[:prefix], lid)
    end

    League.running.each do |league|
      # include: [:stats] is not supported anymore :(
      index_name = TireIndex.index_name args[:prefix], league.id

      league.items.find_in_batches() do |batch|
        Tire.index(index_name).import batch, _routing: :user
        puts "Importerd 1000 items"
      end

      league.players.find_in_batches do |batch|
        Tire.index(index_name).import batch
        puts "Imported 1000 players in #{index_name}"
      end
    end
  end

  task :index_exiles, [:prefix] => :environment do |t, args|
    index_name = "poe_#{args[:prefix]}_exiles"
    index = Tire.index(index_name)
    index.create(mappings: Exile.tire.mapping_to_hash, settings: {})

    a = Tire::Alias.new
    a.index index_name
    a.name Exile.tire.index_name
    a.save

    Exile.find_each &:update_index
  end

  def mappings
    TireIndex.mappings
  end

  task :reindex, [:prefix, :env] => :environment do |t, args|
    League.running.each do |league|
      lid = league.id
      index_name = TireIndex.index_name(args[:prefix, lid)
      index = Tire.index(index_name)
      index.create(mappings: mappings, settings: {})
      # Tire::Tasks::Import.create_index(index, )
    end

    League.running.each do |league|
      # include: [:stats] not support in rails 4
      index_name = TireIndex.index_name(args[:prefix], league.id)

      league.items.find_in_batches() do |batch|
        Tire.index(index_name).import batch, _routing: :user
        puts "Imported 1000 items in #{index_name}"
      end

      league.players.find_in_batches do |batch|
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
      a.index TireIndex.index_name(args[:new_index_prefix], lid)
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

      Tire.index(TireIndex.index_name(args[:prefix], lid)).delete
    end
  end

  task :reset_all_the_things => :environment do
    `rake db:drop db:create db:migrate db:seed;`
    `curl -XDELETE 'http://localhost:9200/_all'`
    `bundle exec rake 'index:index[lala]'`
  end

end
