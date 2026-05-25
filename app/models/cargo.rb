class Cargo < ApplicationRecord
    validates :nombre_cargo, presence: true, uniqueness: true
    has_many :administrativos
    has_many :obreros
end
