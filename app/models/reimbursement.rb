# frozen_string_literal: true

class Reimbursement < ApplicationRecord
  has_many :payment_reimbursements, dependent: :destroy
  has_many :payments, through: :payment_reimbursements

  # Active Storage para comprovante de reembolso
  has_one_attached :reimbursement_proof

  validates :code, presence: true, uniqueness: true
end

