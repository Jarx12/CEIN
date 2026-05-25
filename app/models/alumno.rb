class Alumno < ApplicationRecord
  belongs_to :representante, foreign_key: :representante_id, primary_key: :cedula

  # Representante Secundario (Opcional)
  belongs_to :representante_secundario, 
             class_name: "Representante", 
             foreign_key: :representante_secundario_id, 
             primary_key: :cedula, 
             optional: true

  has_many :enrollments
  accepts_nested_attributes_for :enrollments, allow_destroy: true
  has_many :academic_periods, through: :enrollments 
  has_many :attendances

  validates :name, presence: true
  validates :apellido, presence: true
  validates :representante_id, presence: true
  validates :birthday, presence: true
  has_one_attached :acta_nacimiento

  validates :acta_nacimiento, content_type: [:pdf, 'image/png', 'image/jpeg'],
                              size: { less_than: 5.megabytes , message: 'es muy pesado (máximo 5MB)' }

  def nombre_completo
    "#{name} #{apellido}"
  end

  # Método para obtener la sección actual del alumno
  def seccion_actual
    enrollments.joins(:academic_period)
               .find_by(academic_periods: { status: :active })&.seccion
  end

  # Método para saber el grado/nivel actual
  def grado_actual
    enrollments.joins(:academic_period)
               .find_by(academic_periods: { status: :active })&.grade_level
  end
  
  def representantes_diferentes
    if representante_secundario_id.present? && representante_id == representante_secundario_id
      errors.add(:representante_secundario_id, "no puede ser la misma persona que el representante principal")
  end
  def age
  return unless birthday
  ((Time.zone.now - birthday.to_time) / 1.year.seconds).floor
  end
  
end
end
