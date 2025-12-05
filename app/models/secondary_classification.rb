# frozen_string_literal: true

class SecondaryClassification < ApplicationRecord
  belongs_to :primary_classification
  has_many :payments, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :primary_classification_id }
end

