class Asignatura < ApplicationRecord
    belongs_to :nivel
    validates :nombre_asignatura, presence: true
    validates :codigo_asignatura, presence: true, uniqueness: true
    validates :nivel_id, presence: true
    has_many :scores

    def nombre_asignatura_con_codigo
        "#{nombre_asignatura} - (#{codigo_asignatura})"
    end
end
