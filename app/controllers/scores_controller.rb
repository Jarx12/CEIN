class ScoresController < ApplicationController
  before_action :set_score, only: %i[edit update destroy]
  before_action :authenticate_admin!

  def index
    # 1. Tu lógica original para el listado inferior (Periodo actual)
    @enrollments_con_notas = Enrollment.joins(:scores)
                                       .where(academic_period: AcademicPeriod.current)
                                       .distinct
                                       .includes(:alumno)

    # 2. Lógica 100% Rails para el Buscador Histórico
    @periodo_seleccionado_id = params[:historico_periodo_id]
    @seccion_seleccionada_id = params[:historico_seccion_id]

    if @periodo_seleccionado_id.present? && @seccion_seleccionada_id.present?
      @enrollments_filtrados = Enrollment.where(
        academic_period_id: @periodo_seleccionado_id,
        seccion_id: @seccion_seleccionada_id
      ).includes(:alumno).order("alumnos.apellido ASC")
    else
      @enrollments_filtrados = []
    end
  end

  def new
    @seccion = Seccion.find_by(id: params[:seccion_id])
    @subject = Asignatura.find_by(id: params[:subject_id])
    
    @score = Score.new(asignatura: @subject)
    
    if @seccion
      @enrollments = @seccion.enrollments.where(academic_period: AcademicPeriod.current).includes(:alumno)
    else
      redirect_to selector_scores_path(mode: 'individual'), alert: "Debe seleccionar una sección primero."
    end
  end

  def create
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
    
    if params[:periodo_id].present?
      @periodo_consultado = AcademicPeriod.find(params[:periodo_id])
    else
      @periodo_consultado = AcademicPeriod.current
    end

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
    @mode = params[:mode] || 'individual' 
    @seccion = Seccion.find_by(id: params[:seccion_id])
    
    if @seccion
      @asignaturas = Asignatura.where(nivel_id: @seccion.nivel_id)
    else
      @asignaturas = []
    end
  end

  def bulk_edit
    @seccion = Seccion.find(params[:seccion_id])
    @subject = Asignatura.find(params[:subject_id])
    
    @enrollments = Enrollment.where(
      seccion: @seccion, 
      academic_period: AcademicPeriod.current
    ).includes(:alumno)
    
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

  def convert_nota(valor)
    return valor if valor.is_a?(Numeric) || valor.match?(/^\d+$/)
    
    case valor.to_s.upcase
    when 'A' then 20
    when 'B' then 15
    when 'C' then 10
    when 'D' then 5
    when 'E' then 0
    else valor
    end
  end

  def authenticate_admin!
    unless current_user&.admin? || current_user&.directora?
      logger.warn "ALERTA DE SEGURIDAD: Usuario #{current_user&.email_address} intentó acceder a Admin Calificaciones."
      redirect_to dashboard_path_for_current_user, alert: "No tienes permisos para acceder a este panel."
    end
  end 

end # Cierre final de la clase ScoresController