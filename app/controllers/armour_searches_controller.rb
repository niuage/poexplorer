class ArmourSearchesController < ::SearchesController
  def typed_search
    ArmourSearch
  end

  def new_polymorphic_search_path
    new_armour_search_path
  end

  def search_params
    params[:armour_search]
  end

  def form_decorator_class
    ArmourSearchFormDecorator
  end
end
