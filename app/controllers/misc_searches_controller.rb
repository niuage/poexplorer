class MiscSearchesController < ::SearchesController
  def typed_search
    MiscSearch
  end

  def new_polymorphic_search_path
    new_misc_search_path
  end

  def search_params
    params[:misc_search]
  end

  def form_decorator_class
    MiscSearchFormDecorator
  end
end
