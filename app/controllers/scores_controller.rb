class ScoresController < ApplicationController
  before_action :set_score, only: %i[edit update destroy]

def index
  # 1. Tu lógica original para el listado inferior (Periodo actual)
  @enrollments_con_notas = Enrollment.joins(:scores)
                                     .where(academic_period: AcademicPeriod.current)
                                     .distinct
                                     .includes(:alumno)

  # 2. Lógica 100% Rails para el Buscador Histórico
  # Capturamos lo que venga del formulario
  @periodo_seleccionado_id = params[:historico_periodo_id]
  @seccion_seleccionada_id = params[:historico_seccion_id]

  if @periodo_seleccionado_id.present? && @seccion_seleccionada_id.present?
    # Buscamos las matrículas (enrollments) que coincidan con ese salón y ese año
    @enrollments_filtrados = Enrollment.where(
      academic_period_id: @periodo_seleccionado_id,
      seccion_id: @seccion_seleccionada_id
    ).includes(:alumno).order("alumnos.apellido ASC")
  else
    @enrollments_filtrados = []
  end
end

  def new
    # Si venimos del selector, ya tendremos seccion_id y subject_id
    @seccion = Seccion.find_by(id: params[:seccion_id])
    @subject = Asignatura.find_by(id: params[:subject_id])
    
    @score = Score.new(asignatura: @subject)
    
    if @seccion
      # Solo alumnos de esta sección en el periodo actual
      @enrollments = @seccion.enrollments.where(academic_period: AcademicPeriod.current).includes(:alumno)
    else
      # Si alguien entra a /new directamente, redirigimos al selector
      redirect_to selector_scores_path(mode: 'individual'), alert: "Debe seleccionar una sección primero."
    end
  end

  def create
    # Convertimos la nota antes de inicializar
    processed_params = score_params.merge(nota: convert_nota(score_params[:nota]))
    @score = Score.new(processed_params)
    
    if @score.save
      redirect_to alumno_scores_path(@score.enrollment.alumno), 
                  notice: "Calificación guardada correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # Convertimos la nota antes de actualizar
    if @score.update(score_params.merge(nota: convert_nota(score_params[:nota])))
      redirect_to alumno_scores_path(@score.enrollment.alumno), 
                  notice: "Calificación actualizada correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def bulk_update
    raw_scores = params[:scores]
    if raw_scores.blank?
      redirect_to selector_scores_path, alert: "No se recibieron datos." and return
    end

    Score.transaction do
      raw_scores.each do |key, s_params|
        next if s_params[:nota].blank?

        score = Score.find_or_initialize_by(
          enrollment_id: s_params[:enrollment_id],
          asignatura_id: s_params[:asignatura_id],
          lapso: s_params[:lapso]
        )
        
        # Convertimos la letra a número aquí también
        score.update!(nota: convert_nota(s_params[:nota]))
      end
    end

    redirect_to scores_path, notice: "Notas actualizadas exitosamente."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to selector_scores_path, alert: "Error en los datos: #{e.record.errors.full_messages.join(', ')}"
  rescue => e
    redirect_to selector_scores_path, alert: "Ocurrió un error: #{e.message}"
  end

  def notas_por_alumno
    @alumno = Alumno.find(params[:id])
    
    # 📑 Si pasamos un periodo por el formulario lo usamos, si no, usamos el actual por defecto
    if params[:periodo_id].present?
      @periodo_consultado = AcademicPeriod.find(params[:periodo_id])
    else
      @periodo_consultado = AcademicPeriod.current
    end

    # Buscamos la matrícula correspondiente a ESE año escolar específico
    @enrollment = @alumno.enrollments.find_by(academic_period: @periodo_consultado)

    if @enrollment
      @scores = @enrollment.scores.includes(:asignatura)
    else
      @scores = []
      flash.now[:notice] = "Este alumno no tiene una matrícula registrada en el periodo #{@periodo_consultado&.name}."
    end
  end

  def destroy
    @score.destroy
    redirect_to scores_path
  end

def selector
  # Guardamos el modo (individual o masiva) para saber a dónde enviar el form
  @mode = params[:mode] || 'individual' 
  @seccion = Seccion.find_by(id: params[:seccion_id])
  
  if @seccion
    # Filtramos las asignaturas por el nivel de la sección
    @asignaturas = Asignatura.where(nivel_id: @seccion.nivel_id)
  else
    @asignaturas = []
  end
end

def bulk_edit
@seccion = Seccion.find(params[:seccion_id])
    @subject = Asignatura.find(params[:subject_id])
    
    # only show students currently enrolled in this section for the active period
    @enrollments = Enrollment.where(
      seccion: @seccion, 
      academic_period: AcademicPeriod.current
    ).includes(:alumno) # .includes avoids N+1 query
    
    if @enrollments.empty?
      redirect_to selector_scores_path, alert: "No hay alumnos inscritos en esta sección."
    end
end

  private

  def set_score
    @score = Score.find(params[:id])
  end

  def score_params
    params.require(:score).permit(:nota, :asignatura_id, :enrollment_id, :lapso)
  end

  # Lógica de conversión centralizada
  def convert_nota(valor)
    return valor if valor.is_a?(Numeric) || valor.match?(/^\d+$/) # Si ya es número, lo dejamos
    
    case valor.to_s.upcase
    when 'A' then 20
    when 'B' then 15
    when 'C' then 10
    when 'D' then 5
    when 'E' then 0
    else valor # Si mandan algo diferente, que la validación falle
    end
  end
end