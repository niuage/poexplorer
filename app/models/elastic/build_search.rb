class Elastic::BuildSearch < Elastic::BaseItemSearch
  def tire_search
    searchable = self
    search = self.search
    Tire.search(Build.index_name) do
      query do
        boolean do
          searchable.context = self

          searchable.must_exist(:published_at) unless search.include_drafts

          must { string search.keywords } if search.keywords.present?

          must { string "klass_ids:#{search.klass_ids.join(" ")}" } if search.klass_ids.present?
          must { string "unique_ids:#{search.unique_ids.join(" ")}" } if search.unique_ids.present?
          must { string "skill_gem_ids:#{search.skill_gem_ids.join(" ")}" } if search.skill_gem_ids.present?
          must { string "keystone_ids:#{search.keystone_ids.join(" ")}" } if search.keystone_ids.present?

          must {
            boolean minimum_number_should_match: 1 do
              should { term :softcore, true } if search.softcore
              should { term :hardcore, true } if search.hardcore
              should { term :pvp, true } if search.pvp
            end
          }

          must { term :user_id, search.user_uid } if search.user_uid.present?

          must { term :life_type, search.life_type } if search.life_type.present?
        end
      end

      facet "klasses" do
        terms :klass_names
      end

      facet "gems" do
        terms :skill_gem_names, size: 5
      end

      facet "keystones" do
        terms :keystone_names
      end

      facet "uniques" do
        terms :unique_names, size: 5
      end

      searchable.paginate(self)

      sort do
        if search.order.present?
          case search.order
          when "Date submitted"
            by "published_at", order: "desc"
          when "Rating"
            by "votes", order: "desc"
          end
        else
          by "published_at", order: "desc"
        end
      end
    end
  end

end
