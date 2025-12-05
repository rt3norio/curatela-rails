class CreateCurateladoCurators < ActiveRecord::Migration[8.1]
  def change
    create_table :curatelado_curators do |t|
      t.references :curatelado, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :is_owner, default: false, null: false

      t.timestamps
    end
    
    add_index :curatelado_curators, [:curatelado_id, :user_id], unique: true
  end
end
