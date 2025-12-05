# frozen_string_literal: true

class Partner < ApplicationRecord
  belongs_to :curatelado, optional: true
  has_many :payments, dependent: :nullify

  validates :name, presence: true
  validates :cpf_cnpj, presence: true
  validates :cpf_cnpj, uniqueness: { scope: :curatelado_id }
  
  scope :by_curatelado, ->(curatelado_id) { where(curatelado_id: curatelado_id) }
  
  def display_name
    "#{name} - #{cpf_cnpj}"
  end
end
