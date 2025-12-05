class CreatePartners < ActiveRecord::Migration[8.1]
  def change
    create_table :partners do |t|
      t.string :name, null: false
      t.string :cpf_cnpj, null: false
      t.references :curatelado, null: true, foreign_key: true

      t.timestamps
    end
    
    add_index :partners, :name
    add_index :partners, :cpf_cnpj
    add_index :partners, [:curatelado_id, :cpf_cnpj], unique: true
  end
end
