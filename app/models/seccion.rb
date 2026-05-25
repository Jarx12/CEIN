class Seccion < ApplicationRecord
  belongs_to :nivel
  belongs_to :docente
  
  has_many :enrollments, dependent: :destroy
  # Relación específica para el periodo actual (Optimiza tus otros métodos)
  has_many :current_enrollments, -> { where(academic_period: AcademicPeriod.current) }, 
           class_name: 'Enrollment'
           
  has_many :alumnos, through: :enrollments
  
  validates :nombre_seccion, presence: true, uniqueness: true
  validates :numero_salon, presence: true
  validates :capacidad, presence: true, numericality: { greater_than: 0 }

  
  
  def alumnos_activos
    # Usamos la relación filtrada para ser más eficientes
    alumnos.merge(current_enrollments)
  end
  
  def tiene_cupo?
    current_enrollments.count < capacidad
  end
  
  def cupos_disponibles
    capacidad - current_enrollments.count
  end
  
  def nombre_seccion_con_cupo
    inscritos = current_enrollments.count
    disponibles = capacidad - inscritos
    
    if disponibles <= 0
      "#{nombre_seccion} (LLENA - 0 cupos)"
    else
      "#{nombre_seccion} (#{disponibles} cupos disponibles)"
    end
  end
end