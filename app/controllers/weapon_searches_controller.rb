class WeaponSearchesController < ::SearchesController
  def typed_search
    WeaponSearch
  end

  def new_polymorphic_search_path
    new_weapon_search_path
  end

  def search_params
    params[:weapon_search]
  end

  def form_decorator_class
    WeaponSearchFormDecorator
  end
end
