# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :primary_classification, null: false, foreign_key: true
      t.references :secondary_classification, null: false, foreign_key: true
      t.text :description
      t.string :cpf_cnpj
      t.decimal :value, precision: 10, scale: 2, null: false
      t.date :date, null: false
      t.string :payment_method
      t.string :reimbursement_code

      t.timestamps
    end

    add_index :payments, :cpf_cnpj
    add_index :payments, :date
    add_index :payments, :reimbursement_code
  end
end

