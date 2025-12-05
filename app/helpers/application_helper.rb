module ApplicationHelper
  def format_currency(value)
    number_to_currency(value, unit: "R$ ", separator: ",", delimiter: ".", precision: 2)
  end
end
