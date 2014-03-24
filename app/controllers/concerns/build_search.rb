module Concerns
  module BuildSearch
    extend ActiveSupport::Concern

    included do
      before_filter :find_search, only: [:show, :edit, :update]
    end

    private

    def search
      build_search
      update_from_url_params(@search)

      @searchable = Elastic::BuildSearch.new(@search, params)
      @tire_search = @searchable.tire_search
      @results = BuildDecorator.decorate_collection(@tire_search.results)
    end

    def update_from_url_params(search)
      if (klass_id = params[:class]).present?
        klass_id = Klass.select("id").find_by(name: klass_id).try :id
      end

      if (skill_gem_id = params[:gem]).present?
        skill_gem_id = SkillGem.select("id").find_by(name: skill_gem_id).try :id
      end

      if (unique_id = params[:unique]).present?
        unique_id = Unique.select("id").find_by(name: unique_id).try :id
      end

      if (keystone_id = params[:keystone]).present?
        keystone_id = Keystone.select("id").find_by(name: keystone_id).try :id
      end


      attrs = {}

      attrs.merge!({
        skill_gem_ids: [skill_gem_id.to_i]
        }) if skill_gem_id.present?

      attrs.merge!({
        klass_ids: [klass_id.to_i]
        }) if klass_id.present?

      attrs.merge!({
        unique_ids: [unique_id.to_i]
        }) if unique_id.present?

      attrs.merge!({
        keystone_ids: [keystone_id]
      }) if keystone_id.present?

      search.assign_attributes attrs
    end

    def build_search
      return if @search
      @search = ::BuildSearch.new(search_params)
    end

    def search_params
      params[:search]
    end

    def location
      @search.errors.any? ? nil : @search
    end

    def find_search
      @search = ::BuildSearch.find_by(uid: params[:id])
      return redirect_to(root_url, notice: "This search could not be found, sorry.") unless @search
    end

  end
end
