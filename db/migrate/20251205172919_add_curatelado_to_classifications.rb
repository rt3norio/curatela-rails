class AddCurateladoToClassifications < ActiveRecord::Migration[8.1]
  def change
    add_reference :primary_classifications, :curatelado, null: true, foreign_key: true
    add_reference :secondary_classifications, :curatelado, null: true, foreign_key: true
  end
end
