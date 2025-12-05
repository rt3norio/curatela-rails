class CreateCuratelados < ActiveRecord::Migration[8.1]
  def change
    create_table :curatelados do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
    
    add_index :curatelados, :name
  end
end
