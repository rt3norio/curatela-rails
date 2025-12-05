# frozen_string_literal: true

class CreateReimbursements < ActiveRecord::Migration[8.1]
  def change
    create_table :reimbursements do |t|
      t.string :code, null: false

      t.timestamps
    end

    add_index :reimbursements, :code, unique: true
  end
end

