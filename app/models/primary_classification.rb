# frozen_string_literal: true

class PrimaryClassification < ApplicationRecord
  belongs_to :curatelado, optional: true
  has_many :secondary_classifications, dependent: :destroy
  has_many :payments, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :curatelado_id }
  
  scope :by_curatelado, ->(curatelado_id) { where(curatelado_id: curatelado_id) }
end

