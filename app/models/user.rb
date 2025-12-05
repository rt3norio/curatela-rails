# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Active Storage para foto de perfil
  has_one_attached :profile_picture

  # Curatelado relationships
  has_many :curatelado_curators, dependent: :destroy
  has_many :curatelados, through: :curatelado_curators
  has_many :owned_curatelados, -> { where(curatelado_curators: { is_owner: true }) }, 
           through: :curatelado_curators, source: :curatelado
  has_many :payments_as_curator, class_name: 'Payment', foreign_key: 'curator_id', dependent: :nullify
  has_many :reimbursements_as_curator, class_name: 'Reimbursement', foreign_key: 'curator_id', dependent: :nullify

  # Validações
  validates :email, presence: true, uniqueness: true
end


