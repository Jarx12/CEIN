class Enrollment < ApplicationRecord
  belongs_to :alumno
  belongs_to :academic_period
  belongs_to :seccion
  has_many :scores, dependent: :destroy
  enum :status, { active: 0, retirado: 3 }, default: :active
  enum :approval_status, { pendiente: 0, confirmado: 1, rechazado: 2 }, default: :pendiente
  enum :withdrawal_reason, {traslado_voluntario: 0, egreso_maximo_nivel: 1 }, default: :traslado_voluntario
  
  before_validation :set_default_status, on: :create

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
  def set_default_status
      # El operador ||= significa: "Si status es nil, asignar :active. Si ya trae algo, no modificar"
      self.status ||= :active
  end
end
