# frozen_string_literal: true

class CreateSecondaryClassifications < ActiveRecord::Migration[8.1]
  def change
    create_table :secondary_classifications do |t|
      t.string :name, null: false
      t.references :primary_classification, null: false, foreign_key: true

      t.timestamps
    end

    add_index :secondary_classifications, [:primary_classification_id, :name], unique: true, name: 'index_secondary_on_primary_and_name'
  end
end

