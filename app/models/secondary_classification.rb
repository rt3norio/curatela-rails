# frozen_string_literal: true

class SecondaryClassification < ApplicationRecord
  belongs_to :primary_classification
  belongs_to :curatelado, optional: true
  has_many :payments, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: [:primary_classification_id, :curatelado_id] }
  
  scope :by_curatelado, ->(curatelado_id) { where(curatelado_id: curatelado_id) }
end

