class Administrativo < ApplicationRecord
  has_one_attached :foto_titulo
  has_one_attached :antecedentes_penales
  
  belongs_to :cargo

  validates :name, presence: true
  validates :apellido, presence: true
  validates :cedula, presence: true
  validates :direccion, presence: true
  validates :birthday, presence: true
  validates :cargo_id, presence: true
end
