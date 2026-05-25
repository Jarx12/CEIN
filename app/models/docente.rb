class Docente < ApplicationRecord
  has_many :seccions
  has_one_attached :foto_titulo
  has_one_attached :antecedentes_penales
  
  validates :name, presence: true
  validates :apellido, presence: true
  validates :cedula, presence: true
  validates :birthday, presence: true
  validates :direccion, presence: true
  validates :telefono, presence: true


  def nombre_completo
    "#{name} #{apellido}"
  end

end
