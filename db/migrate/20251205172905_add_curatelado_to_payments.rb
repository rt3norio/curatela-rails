class AddCurateladoToPayments < ActiveRecord::Migration[8.1]
  def change
    add_reference :payments, :curatelado, null: true, foreign_key: true
    add_reference :payments, :curator, null: true, foreign_key: { to_table: :users }
  end
end
