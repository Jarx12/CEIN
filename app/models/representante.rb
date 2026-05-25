class Representante < ApplicationRecord
  has_many :alumno

  # Alumnos donde es el secundario
  has_many :alumno_secundario, 
           class_name: "Alumno", 
           foreign_key: :representante_secundario_id, 
           primary_key: :cedula

  validates :name, presence: true
  validates :apellido, presence: true
  validates :cedula, presence: true, uniqueness: true
  validates :direccion, presence: true
  validates :birthday, presence: true

  def full_name
    "#{name} #{apellido}".strip
  end
end
