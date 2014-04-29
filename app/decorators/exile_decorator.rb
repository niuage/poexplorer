class ExileDecorator < ApplicationDecorator
  delegate_all

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
