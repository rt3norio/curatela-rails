# frozen_string_literal: true

class CreatePrimaryClassifications < ActiveRecord::Migration[8.1]
  def change
    create_table :primary_classifications do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :primary_classifications, :name, unique: true
  end
end

