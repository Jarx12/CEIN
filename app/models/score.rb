class Score < ApplicationRecord
    belongs_to :asignatura
    belongs_to :enrollment
    delegate :alumno, to: :enrollment
    validates :asignatura_id, presence: true
    validates :nota, presence:true, numericality: 
    {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 20,
    }
    validates :lapso, presence: true, inclusion: { in: [1, 2, 3] }
    validates :lapso, uniqueness: { scope: [:enrollment_id, :asignatura_id], 
                message: "ya tiene una nota registrada para este lapso" }

def self.convertir_a_letra(valor_num)
    case valor_num.to_f.round
    when 16..20 then 'A' 
    when 11..15 then 'B' 
    when 10     then 'C' 
    when 1..9   then 'D' 
    else 'E'             
    end
  end

  def nota_letra
    Score.convertir_a_letra(self.nota)
  end

  def self.convert_nota(valor)
    # Si ya es un número (o un string numérico), lo devolvemos tal cual
    return valor.to_i if valor.to_s.match?(/^\d+$/)

case valor.to_s.upcase.strip
    when 'A' then 20 
    when 'B' then 15 
    when 'C' then 10 
    when 'D' then 5  
    when 'E' then 0 
    else 0
    end
  end


end
