# frozen_string_literal: true

class CurateladoCurator < ApplicationRecord
  belongs_to :curatelado
  belongs_to :user

  validates :user_id, uniqueness: { scope: :curatelado_id }
end
