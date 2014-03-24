class ArmourSearchesController < ::SearchesController
  def typed_search
    ArmourSearch
  end

  def search_params
    params[:armour_search]
  end

  def form_decorator_class
    ArmourSearchFormDecorator
  end
end
