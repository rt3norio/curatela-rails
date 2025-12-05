# frozen_string_literal: true

class PrimaryClassification < ApplicationRecord
  has_many :secondary_classifications, dependent: :destroy
  has_many :payments, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end

