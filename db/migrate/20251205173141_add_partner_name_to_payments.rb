class AddPartnerNameToPayments < ActiveRecord::Migration[8.1]
  def change
    add_column :payments, :partner_name, :string
    add_index :payments, :partner_name
  end
end
