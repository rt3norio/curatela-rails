# frozen_string_literal: true

class Curatelado < ApplicationRecord
  has_many :curatelado_curators, dependent: :destroy
  has_many :curators, through: :curatelado_curators, source: :user
  has_many :payments, dependent: :destroy
  has_many :reimbursements, dependent: :destroy
  has_many :primary_classifications, dependent: :destroy
  has_many :secondary_classifications, dependent: :destroy
  has_many :partners, dependent: :destroy

  validates :name, presence: true
  
  def owner
    curatelado_curators.find_by(is_owner: true)&.user
  end
  
  def co_curators
    curators.where.not(id: owner&.id)
  end
end
