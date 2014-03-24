class ApplicationDecorator < Draper::Decorator
end

Draper::CollectionDecorator.delegate :current_page, :total_pages, :limit_value, :total_count, :facets
