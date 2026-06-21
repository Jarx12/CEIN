class AlumnosController < ApplicationController

before_action :set_alumno, only: %i[show edit update destroy retirar procesar_retiro reincorporar] #Antes de show edit, update y destroy, se ejecuta set_alumno (guardar en una variable un registro del modelo Alumno por ID)
before_action :authenticate_users!
before_action :authenticate_academic_author!, only: [:confirmar_inscripcion, :destroy, :reincorporar, :procesar_retiro]

def index
  @periodo_activo = AcademicPeriod.find_by(status: :active)

  if @periodo_activo
    # Buscamos de forma estricta usando las llaves de tu enum real: "active" y "confirmado"
    # Al incluir el soporte para NULL, rescatamos a cualquier alumno viejo cuyo campo haya quedado vacío
@alumnos = Alumno.joins(:enrollments)
                     .where(enrollments: { 
                       academic_period_id: @periodo_activo.id, 
                       approval_status: 1, 
                       status: 0 
                     })
                     .distinct
  else
    @alumnos = Alumno.all
  end
end

  def show
  end

  def new
    @alumno = Alumno.new
  end

  def create
    @alumno = Alumno.new(alumno_params)
    if @alumno.save
      redirect_to alumnos_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

def update
  respond_to do |format|
    if @alumno.update(alumno_params)
      if params[:from] == 'revision'
        format.html { redirect_to revision_alumnos_path, notice: "Alumno actualizado con éxito." }
      else
        format.html { redirect_to alumno_path(@alumno), notice: "Alumno actualizado con éxito." }
      end
      
      format.json { render :show, status: :ok, location: @alumno }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @alumno.errors, status: :unprocessable_entity }
    end
  end
end
  
  def destroy
    @alumno.destroy
    redirect_to alumnos_path
  end

  def seccion_actual
    # Busca la inscripción del periodo activo y devuelve la sección
    enrollments.joins(:academic_period)
               .find_by(academic_periods: { status: :active })&.seccion
  end

  def revision
    @periodo_activo = AcademicPeriod.find_by(status: :active)

    if @periodo_activo
      # CASO A: Inscripciones creadas para este periodo pendientes por confirmación de Dirección
      @inscripciones_pendientes = Enrollment.where(academic_period: @periodo_activo, approval_status: :pendiente)
                                            .includes(:alumno, :seccion)

      # CASO B: Alumnos que NO tienen absolutamente ninguna inscripción en el periodo actual
      inscritos_ids = Enrollment.where(academic_period: @periodo_activo).select(:alumno_id)

      # 🚀 EL FILTRO ANTIFANTASMAS DEFINITIVO:
      # Seleccionamos a los alumnos cuyo ÚLTIMO enrollment en la historia del sistema tenga status = 3 (retirado)
      # Esto usa SQL puro para buscar por grupo el registro más nuevo ('MAX(id)') de cada alumno.
      ultimos_enrollments_retirados = Enrollment.where(
        id: Enrollment.select("MAX(id)").group(:alumno_id),
        status: 3
      ).select(:alumno_id)

      # Trae alumnos sin inscripción este año, EXCLUYENDO a los que su último estado histórico sea 'retirado'
      @alumnos_sin_seccion = Alumno.where.not(id: inscritos_ids)
                                  .where.not(id: ultimos_enrollments_retirados)
    else
      @inscripciones_pendientes = []
      @alumnos_sin_seccion = Alumno.all
    end
  end

  # PATCH /alumnos/confirmar_inscripcion/:id
  def confirmar_inscripcion
    @inscripcion = Enrollment.find(params[:id])
    
    if @inscripcion.confirmado!
      flash[:notice] = "Inscripción aprobada: #{@inscripcion.alumno.nombre_completo} ha sido asignado oficialmente a la sección #{@inscripcion.seccion.nombre_seccion}."
    else
      flash[:alert] = "No se pudo procesar la confirmación del cupo."
    end
    
    redirect_to revision_alumnos_path
  end

  # GET /alumnos/:id/retirar
  def retirar
    @periodo_activo = AcademicPeriod.find_by(status: :active)
    @enrollment_actual = @alumno.enrollments.find_by(academic_period: @periodo_activo)

    if @enrollment_actual.nil?
      redirect_to alumnos_path, alert: "El alumno no posee una matrícula activa en este periodo para ser retirado."
    end
  end

  # PATCH /alumnos/:id/procesar_retiro
  def procesar_retiro
    @periodo_activo = AcademicPeriod.find_by(status: :active)
    @enrollment_actual = @alumno.enrollments.find_by(academic_period: @periodo_activo)

    # Actualizamos el estado de la matrícula a retirado y guardamos el motivo del traslado
    if @enrollment_actual.update(status: :retirado, withdrawal_reason: params[:withdrawal_reason])
      flash[:notice] = "El alumno #{@alumno.nombre_completo} ha sido retirado del plantel exitosamente."
      redirect_to alumnos_path
    else
      flash[:alert] = "No se pudo procesar el retiro del alumno."
      render :retirar, status: :unprocessable_entity
    end
  end

  def retirados
      @periodo_activo = AcademicPeriod.find_by(status: :active)
      
      if @periodo_activo
        # Buscamos estrictamente los alumnos cuyo enrollment de este periodo tenga status: 3 (:retirado)
        @alumnos_retirados = Alumno.joins(:enrollments)
                                  .where(enrollments: { 
                                    academic_period_id: @periodo_activo.id, 
                                    status: 3 
                                  })
                                  .distinct
      else
        @alumnos_retirados = []
      end
    end

    # PATCH /alumnos/:id/reincorporar
    def reincorporar
      @periodo_activo = AcademicPeriod.find_by(status: :active)
      @enrollment = @alumno.enrollments.find_by(academic_period: @periodo_activo)

      # Revertimos el estatus a 0 (:active) y limpiamos el motivo del retiro poniendo nil
      if @enrollment.update(status: 0, withdrawal_reason: nil)
        flash[:notice] = "El alumno #{@alumno.nombre_completo} ha sido reincorporado al plantel con éxito."
        redirect_to alumnos_path # Lo mandamos al index normal donde ahora sí va a aparecer
      else
        flash[:alert] = "No se pudo procesar la reincorporación."
        redirect_to retirados_alumnos_path
      end
    end

  def archivo_historico
    @periodo_activos_todos = AcademicPeriod.order(created_at: :desc)
    @periodo_actual = AcademicPeriod.find_by(status: :active)

    # 1. Capturamos el periodo seleccionado del dropdown, o calculamos el anterior por defecto
    if params[:periodo_consulta_id].present?
      @periodo_consultado = AcademicPeriod.find(params[:periodo_consulta_id])
    else
      # Busca el periodo más reciente que NO sea el activo actual
      @periodo_consultado = AcademicPeriod.where.not(status: :active).order(created_at: :desc).first
    end

    if @periodo_consultado
      # 2. Buscamos los alumnos cuyo ÚLTIMO estado en el periodo consultado fue 'retirado' (status: 3)
      # Y nos aseguramos de que NO estén ya inscritos en el periodo actual
      inscritos_actualmente_ids = Enrollment.where(academic_period: @periodo_actual).select(:alumno_id) if @periodo_actual

      @alumnos_historicos = Alumno.joins(:enrollments)
                                  .where(enrollments: { 
                                    academic_period_id: @periodo_consultado.id, 
                                    status: 3 
                                  })
                                  .where.not(id: inscritos_actualmente_ids || [])
                                  .distinct
    else
      @alumnos_historicos = []
    end
  end

    # POST /alumnos/:id/reinscribir_historico
  def reinscribir_historico
    @alumno = Alumno.find(params[:id])
    @periodo_activo = AcademicPeriod.find_by(status: :active)

    unless @periodo_activo
      flash[:alert] = "No hay un periodo académico activo para procesar inscripciones."
      return redirect_to @alumno
    end

    # Validamos que el alumno no tenga ya una inscripción este año (por seguridad)
    if @alumno.enrollments.exists?(academic_period: @periodo_activo)
      flash[:alert] = "El alumno ya posee una matrícula generada para el periodo actual."
      return redirect_to @alumno
    end

    # Creamos el nuevo enrollment en el año vigente.
    # Gracias al callback 'before_validation' que pusimos antes, el status nacerá automáticamente en :active (0)
    @nuevo_enrollment = @alumno.enrollments.new(
      academic_period_id: @periodo_activo.id,
      seccion_id: params[:seccion_id], # La seccion elegida en el formulario
      approval_status: :pendiente      # Nace pendiente para que Dirección le dé el visto bueno
    )

    if @nuevo_enrollment.save
      flash[:notice] = "¡Reincorporación exitosa! Se ha generado la matrícula de #{@alumno.nombre_completo} para el periodo #{@periodo_activo.name}."
      redirect_to archivo_historico_alumnos_path # Lo mandamos a la bandeja de revisión para que Dirección lo apruebe
    else
      flash[:alert] = "Error al reinscribir: #{@nuevo_enrollment.errors.full_messages.to_sentence}"
      redirect_to @archivo_historico_alumnos_path
    end
  end

private

  def set_alumno
    @alumno = Alumno.find(params[:id])
  end

  def alumno_params
    params.require(:alumno).permit(
      :name, :name2, :apellido, :apellido2, :representante_id, :birthday, :representante_secundario_id, :acta_nacimiento,
      enrollments_attributes: [:id, :academic_period_id, :seccion_id, :grade_level, :_destroy, :status, :approval_status, :withdrawal_reason]
    )
  end # 🛠️ CORRECCIÓN: Faltaba cerrar este método

  def authenticate_users!
    unless current_user&.admin? || current_user&.directora? || current_user&.coordinadora? || current_user&.secretaria?
      logger.warn "ALERTA DE SEGURIDAD: Usuario #{current_user&.email_address} intentó acceder a Alumnos."
      redirect_to dashboard_path_for_current_user, alert: "No tienes permisos para acceder a este panel."
    end
  end

  def authenticate_academic_author!
    unless current_user&.admin? || current_user&.directora? || current_user&.coordinadora?
      logger.warn "ALERTA DE SEGURIDAD: Usuario #{current_user&.email_address} intentó modificar Alumnos."
      redirect_to dashboard_path_for_current_user, alert: "No tienes permisos para realizar esta operación."
    end
  end

end