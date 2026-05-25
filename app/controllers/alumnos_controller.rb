class AlumnosController < ApplicationController

  before_action :set_alumno, only: %i[show edit update destroy] #Antes de show edit, update y destroy, se ejecuta set_alumno (guardar en una variable un registro del modelo Alumno por ID)

  def index
    @alumnos = Alumno.all
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
    if @alumno.update(alumno_params)
      redirect_to alumno_path(@alumno)
    else
      render :edit, status: :unprocessable_entity
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
