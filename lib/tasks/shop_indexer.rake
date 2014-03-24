namespace :shop do

  desc "Index processed shops"
  task :index, [:force_indexing] => :environment do |t, args|
    force_indexing = args[:force_indexing].to_i
    ShopIndexer.new(force_indexing > 0, logging: true).index_all
  end

  desc "Scrawl path of exile forums"
  task :process => :environment do |t, args|
    ShopIndexer.new(false, logging: true).process_all
  end

  desc "index a shop"
  task :index_shop, [:shop_id] => :environment do |t, args|
    shop = Shop.find(args[:shop_id])
    return unless shop && shop.id.present?

    shop.update_attribute(:processing, true)

    count = Item.where(shop_id: shop.id).count
    return if count > 500
    Item.where(shop_id: shop.id).destroy_all

    if shop.processing
      ShopIndexer.new(false, logging: true).process(shop)
    else
      ShopIndexer.new(false, logging: true).index(shop)
    end

  end

end
