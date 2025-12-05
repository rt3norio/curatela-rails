# frozen_string_literal: true

class Reimbursement < ApplicationRecord
  belongs_to :curatelado, optional: true
  belongs_to :curator, class_name: 'User', optional: true
  has_many :payment_reimbursements, dependent: :destroy
  has_many :payments, through: :payment_reimbursements

  # Active Storage para comprovante de reembolso
  has_one_attached :reimbursement_proof

  validates :code, presence: true, uniqueness: true
  
  scope :by_curatelado, ->(curatelado_id) { where(curatelado_id: curatelado_id) }
end

