class Attendance < ApplicationRecord
  belongs_to :alumno
  validates :fecha, presence: true
end
