# app/controllers/profesor/scores_controller.rb
class Profesor::ScoresController < ApplicationController
  before_action :authenticate_user!
  before_action :check_profesor_role!
  before_action :set_seccion_segura

  def index
  @asignaturas = @seccion.nivel.asignaturas.order(:id)
  @enrollments = @seccion.enrollments
                         .where(academic_period: AcademicPeriod.current)
                         .includes(:alumno, :scores)
                         .order("alumno.apellido ASC")

  @lapso_actual = (params[:lapso] || 1).to_i
  end

def show
  # Buscamos por el ID del enrollment, pero asegurando que pertenezca a la sección del docente
  @enrollment = @seccion.enrollments.find_by(id: params[:id])

  # Si no se encuentra por ID de enrollment, intentamos buscarlo como alumno_id dentro de esa sección
  @enrollment ||= @seccion.enrollments.find_by!(alumno_id: params[:id])

  @alumno = @enrollment.alumno
  @scores = @enrollment.scores.order(:lapso)
  
  # Si quieres filtrar por asignatura si viene el parámetro
  @scores = @scores.where(asignatura_id: params[:subject_id]) if params[:subject_id].present?
end

  def new
    @subject = Asignatura.find_by(id: params[:subject_id])
    # Pre-seleccionamos el enrollment si viene por parámetro
    @score = Score.new(
      asignatura: @subject, 
      enrollment_id: params[:enrollment_id],
      lapso: params[:lapso] || 1
    )
  end

def create
  Score.transaction do
    if params[:scores].present?
      # Caso Planilla Masiva
      params[:scores].each do |enrollment_id, s_params|
        next if s_params[:nota].blank?
        save_score(enrollment_id, s_params)
      end
    elsif params[:score].present?
      # Caso Formulario Individual (Tu caso actual)
      # Pasamos params[:score] que contiene todos los datos
      save_score(params[:score][:enrollment_id], params[:score])
    end
  end
  redirect_to profesor_seccion_path(@seccion), notice: "Calificación guardada correctamente."
rescue ActiveRecord::RecordInvalid => e
  # Si falla una validación, esto nos dirá qué pasó en lugar de no hacer nada
  redirect_to profesor_seccion_path(@seccion), alert: "Error de validación: #{e.record.errors.full_messages.join(', ')}"
rescue => e
  redirect_to profesor_seccion_path(@seccion), alert: "Error: #{e.message}"
end

def planilla
  @lapso_actual = (params[:lapso] || 1).to_i
  @subject = @seccion.nivel.asignaturas.find_by(id: params[:subject_id]) || @seccion.nivel.asignaturas.first
  @enrollments = @seccion.enrollments
                         .where(academic_period: AcademicPeriod.current)
                         .includes(:alumno, :scores)
                         .order("alumno.apellido ASC")
end

def bulk_update
  raw_scores = params[:scores]
  
  if raw_scores.blank?
    redirect_to profesor_seccion_scores_path(@seccion), alert: "No se recibieron datos para actualizar." and return
  end

  begin
    Score.transaction do
      raw_scores.each do |_, s_params|
        # 1. Seguridad: Validamos que el enrollment pertenezca a la sección del profesor
        enrollment = @seccion.enrollments.find(s_params[:enrollment_id])
        
        next if s_params[:nota].blank?

        # 2. Buscamos o inicializamos
        score = Score.find_or_initialize_by(
          enrollment_id: enrollment.id,
          asignatura_id: s_params[:asignatura_id],
          lapso: s_params[:lapso]
        )
        
        # 3. Guardamos usando el método de clase del modelo
        score.nota = Score.convert_nota(s_params[:nota])
        score.save!
      end
    end
    redirect_to profesor_seccion_path(@seccion), notice: "Planilla de notas actualizada exitosamente."
  rescue ActiveRecord::RecordNotFound
    redirect_to profesor_seccion_path(@seccion), alert: "Error de seguridad: Intento de acceso a alumnos no autorizados."
  rescue => e
    redirect_to profesor_seccion_path(@seccion), alert: "Error: #{e.message}"
  end
end


  private

  def set_seccion_segura
    # Suponiendo que current_user es el docente logueado
    @seccion = Seccion.where(docente_id: current_user.person_id).find(params[:seccion_id])
  end

  # Método auxiliar para no repetir código en el create
  def save_score(enrollment_id, s_params)
    enrollment = @seccion.enrollments.find(enrollment_id)
    score = Score.find_or_initialize_by(
      enrollment: enrollment,
      asignatura_id: s_params[:asignatura_id],
      lapso: s_params[:lapso]
    )
    # Importante: Asegúrate de que el modelo Score tenga el método self.convert_nota
    score.update!(nota: Score.convert_nota(s_params[:nota]))
  end
end