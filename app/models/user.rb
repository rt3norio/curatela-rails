# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Active Storage para foto de perfil
  has_one_attached :profile_picture

  # Validações
  validates :email, presence: true, uniqueness: true
end


