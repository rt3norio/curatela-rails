# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :primary_classification
  belongs_to :secondary_classification
  belongs_to :curatelado, optional: true
  belongs_to :curator, class_name: 'User', optional: true
  has_many :payment_reimbursements, dependent: :destroy
  has_many :reimbursements, through: :payment_reimbursements

  # Active Storage para foto do documento
  has_one_attached :document_photo

  validates :primary_classification, presence: true
  validates :secondary_classification, presence: true
  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :document_photo, presence: true, on: :create

  # Validação para garantir que a classificação secundária pertence à primária
  validate :secondary_belongs_to_primary

  scope :by_cpf_cnpj, ->(cpf_cnpj) { where(cpf_cnpj: cpf_cnpj) }
  scope :by_curatelado, ->(curatelado_id) { where(curatelado_id: curatelado_id) }
  scope :distinct_cpf_cnpj, -> { select(:cpf_cnpj).distinct.where.not(cpf_cnpj: [nil, '']).order(:cpf_cnpj) }
  
  # Get distinct partners with their names and CPF/CNPJ for autocomplete
  def self.partner_suggestions(query = nil, curatelado_id = nil)
    payments = curatelado_id ? by_curatelado(curatelado_id) : all
    payments = payments.where.not(cpf_cnpj: [nil, ''])
    
    if query.present?
      sanitized_query = sanitize_sql_like(query)
      payments = payments.where(
        'partner_name LIKE ? OR cpf_cnpj LIKE ?', 
        "%#{sanitized_query}%", "%#{sanitized_query}%"
      )
    end
    
    payments.select('DISTINCT partner_name, cpf_cnpj')
            .where.not(partner_name: [nil, ''])
            .order(:partner_name)
            .limit(20)
            .map { |p| { name: p.partner_name, cpf_cnpj: p.cpf_cnpj, label: "#{p.partner_name} - #{p.cpf_cnpj}" } }
  end

  private

  def secondary_belongs_to_primary
    return unless primary_classification && secondary_classification

    unless secondary_classification.primary_classification_id == primary_classification.id
      errors.add(:secondary_classification, 'deve pertencer à classificação primária selecionada')
    end
  end
end

