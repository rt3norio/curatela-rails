class AddCurateladoToReimbursements < ActiveRecord::Migration[8.1]
  def change
    add_reference :reimbursements, :curatelado, null: true, foreign_key: true
    add_reference :reimbursements, :curator, null: true, foreign_key: { to_table: :users }
  end
end
