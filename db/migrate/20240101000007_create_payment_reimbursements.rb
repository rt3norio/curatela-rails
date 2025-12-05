# frozen_string_literal: true

class CreatePaymentReimbursements < ActiveRecord::Migration[8.1]
  def change
    create_table :payment_reimbursements do |t|
      t.references :payment, null: false, foreign_key: true
      t.references :reimbursement, null: false, foreign_key: true

      t.timestamps
    end

    add_index :payment_reimbursements, [:payment_id, :reimbursement_id], unique: true, name: 'index_payment_reimbursements_unique'
  end
end

