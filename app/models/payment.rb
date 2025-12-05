# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :primary_classification
  belongs_to :secondary_classification
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
  scope :distinct_cpf_cnpj, -> { select(:cpf_cnpj).distinct.where.not(cpf_cnpj: [nil, '']).order(:cpf_cnpj) }

  private

  def secondary_belongs_to_primary
    return unless primary_classification && secondary_classification

    unless secondary_classification.primary_classification_id == primary_classification.id
      errors.add(:secondary_classification, 'deve pertencer à classificação primária selecionada')
    end
  end
end

