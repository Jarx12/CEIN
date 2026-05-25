class AcademicPeriod < ApplicationRecord
  has_many :enrollments
  has_many :students, through: :enrollments
  # estados
  enum :status, { inactive: 0, active: 1, closed: 2 }, default: :inactive

  # validaciones
  validates :name, presence: true, uniqueness: { case_sensitive: false, message: "ya existe un periodo con este nombre" }
  validates :start_date, :end_date, presence: true
  
  # Solo un periodo activo a la vez
  validate :only_one_active_period, if: :active?

  scope :current, -> { find_by(status: :active) }

  
  def self.current
    find_by(status: :active)
  end

def activate!
    # Transacción para asegurar que solo uno quede activo
    AcademicPeriod.transaction do
      AcademicPeriod.where(status: :active).update_all(status: :closed)
      update!(status: :active)
    end
  end

  def close!
    update!(status: :closed)
  end




  private

  def only_one_active_period
    if AcademicPeriod.where.not(id: id).active.exists?
      errors.add(:status, "ya existe un periodo activo actualmente")
    end
  end

end