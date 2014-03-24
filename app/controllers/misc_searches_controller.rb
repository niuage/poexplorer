class MiscSearchesController < ::SearchesController
  def typed_search
    MiscSearch
  end

  def search_params
    params[:misc_search]
  end

  def form_decorator_class
    MiscSearchFormDecorator
  end
end
