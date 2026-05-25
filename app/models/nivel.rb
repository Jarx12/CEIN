class Nivel < ApplicationRecord
    has_many :seccions
    has_many :asignaturas
    validates :nombre_nivel, presence: true, uniqueness: { case_sensitive: false }
    before_save :normalize_name
    
    private
        def normalize_name
        self.nombre_nivel = self.nombre_nivel.squish.titleize
    end
end
