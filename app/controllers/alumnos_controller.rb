class AlumnosController < ApplicationController

  before_action :set_alumno, only: %i[show edit update destroy] #Antes de show edit, update y destroy, se ejecuta set_alumno (guardar en una variable un registro del modelo Alumno por ID)

def index
  @periodo_activo = AcademicPeriod.find_by(status: :active)

  if @periodo_activo
    # CORREGIDO: Muestra en el index principal SOLO a los confirmados del año actual.
    # Al usar 'distinct' evitamos que se dupliquen en pantalla si tienen historial.
    @alumnos = Alumno.joins(:enrollments)
                     .where(enrollments: { academic_period_id: @periodo_activo.id, approval_status: :confirmado })
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
    # 1. Identificamos el periodo escolar que está corriendo actualmente
    @periodo_activo = AcademicPeriod.find_by(status: :active)

    if @periodo_activo
      # CASO A: Tienen una inscripción creada para este periodo pero falta que Dirección la confirme
      @inscripciones_pendientes = Enrollment.where(academic_period: @periodo_activo, approval_status: :pendiente)
                                            .includes(:alumno, :seccion)

      # CASO B: Alumnos del plantel (o nuevos) que NO tienen absolutamente ninguna inscripción en el periodo actual
      # Usamos un subquery con .select(:alumno_id) para encontrar a los excluidos de este año
      inscritos_ids = Enrollment.where(academic_period: @periodo_activo).select(:alumno_id)
      @alumnos_sin_seccion = Alumno.where.not(id: inscritos_ids)
    else
      @inscripciones_pendientes = []
      @alumnos_sin_seccion = Alumno.all # Si no hay periodo activo, todos entran aquí por seguridad
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




  private
    def set_alumno
      @alumno = Alumno.find(params[:id])
    end

  def alumno_params
  params.require(:alumno).permit(
    :name, :name2, :apellido, :apellido2, :representante_id, :birthday, :representante_secundario_id, :acta_nacimiento,
    enrollments_attributes: [:id, :academic_period_id, :seccion_id, :grade_level, :_destroy]
  )
end
end
