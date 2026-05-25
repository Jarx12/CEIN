class Enrollment < ApplicationRecord
  belongs_to :alumno
  belongs_to :academic_period
  belongs_to :seccion
  has_many :scores, dependent: :destroy
  enum :status, { active: 0, aprobado: 1, reprobado: 2, retirado: 3 }, default: :active

  
  validates :alumno_id, uniqueness: { scope: :academic_period_id, message: "ya está inscrito en este periodo" }
  # Validación para no editar nada si el periodo está cerrado
  validate :period_must_be_open, on: :update
  validate :seccion_no_esta_llena, on: :create
  
  def nombre_alumno
    alumno.nombre_completo
  end

  private

  def period_must_be_open
    if academic_period.closed?
      errors.add(:base, "El periodo escolar ya está cerrado y no se puede modificar.")
    end
  end
  
  def seccion_no_esta_llena
    if self.seccion.present? && !self.seccion.tiene_cupo?
      errors.add(:seccion_id, "ha alcanzado su capacidad máxima de #{self.seccion.capacidad} alumnos")
    end
  end
end
