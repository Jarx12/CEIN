class Event < ApplicationRecord
  enum :category, { convocatoria: 0, institucional: 1, administrativo: 2 }

  validates :title, :description, :event_date, presence: true

  # Métodos auxiliares para simplificar las clases visuales de Bootstrap en la vista
  def category_badge_class
    case category
    when "convocatoria" then "bg-danger-subtle text-danger"
    when "institucional" then "bg-success-subtle text-success"
    when "administrativo" then "bg-info-subtle text-info"
    end
  end

  def category_label
    case category
    when "convocatoria" then "⚠️ Convocatoria"
    when "institucional" then "🎉 Institucional"
    when "administrativo" then "📌 Administrativo"
    end
  end
end