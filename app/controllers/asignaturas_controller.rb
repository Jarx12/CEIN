class AsignaturasController < ApplicationController

  before_action :set_asignatura, only: %i[edit update destroy] #Antes de show edit, update y destroy, se ejecuta set_asignatura (guardar en una variable un registro del modelo Asignatura por ID)
  before_action :authenticate_academic_author!

  def index
    @asignaturas = Asignatura.includes(:nivel).all
    if params[:from] == 'zadmin'
      @back_path = zadmin_path
    else
      @back_path = dashboard_path_for_current_user
    end
  end

  def new
    @asignatura = Asignatura.new
  end

  def create
    @asignatura = Asignatura.new(asignatura_params)
    if @asignatura.save
      redirect_to asignaturas_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @asignatura.update(asignatura_params)
      redirect_to asignaturas_path
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @asignatura.destroy
    redirect_to asignaturas_path
  end

  private
    def set_asignatura
      @asignatura = Asignatura.find(params[:id])
    end

    def asignatura_params
      params.require(:asignatura).permit(:nombre_asignatura, :codigo_asignatura, :nivel_id)
    end

  def authenticate_academic_author!
    unless current_user&.admin? || current_user&.directora? || current_user&.coordinadora?
      logger.warn "ALERTA DE SEGURIDAD: Usuario #{current_user&.email_address} intentó modificar Asignaturas."
      redirect_to dashboard_path_for_current_user, alert: "No tienes permisos para realizar esta operación."
    end
  end

end
