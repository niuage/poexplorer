module UserBuilds
  class BuildsController < UserBuildsController
    include Concerns::BuildSearch

    def index
      search
    end

    private

    def build_search
      super
      @search.include_drafts = (@user.id == current_user.try(:id))
    end

    def search_params
      p = (params[:search] || {}).merge(user_uid: @user.id)
    end

  end
end
