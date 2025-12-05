# frozen_string_literal: true

class PaymentReimbursement < ApplicationRecord
  belongs_to :payment
  belongs_to :reimbursement

  validates :payment_id, uniqueness: { scope: :reimbursement_id }
end

