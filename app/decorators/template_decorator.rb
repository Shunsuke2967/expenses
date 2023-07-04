class TemplateDecorator < Draper::Decorator
  delegate_all

  def set_class
    case object.icon
    when 'rent'
      ['icon-color-red', 'fas fa-home']
    when 'food_expenses'
      ['icon-color-yellow', 'fas fa-utensils']
    when 'cost_of_living'
      ['icon-color-lightblue', 'fas fa-faucet']
    when 'entertainment'
      ['icon-color-green', 'fas fa-shopping-cart']
    when 'car_cost'
      ['icon-color-violetgreen', 'fas fa-car-side']
    when 'insurance'
      ['icon-color-violet', 'fas fa-hospital-user']
    when 'payment'
      ['icon-color-gray', 'fas fa-yen-sign']
    when 'other'
      ['icon-color-gray', 'far fa-question-circle']
    else
      ''
    end
  end
end
