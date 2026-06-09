class SeccionsController < ApplicationController

  before_action :set_seccion, only: %i[show edit update destroy] #Antes de show edit, update y destroy, se ejecuta set_seccion (guardar en una variable un registro del modelo Seccion por ID)

  def index
    @seccions = Seccion.all
    if params[:from] == 'zadmin'
      @back_path = zadmin_path
    else
      @back_path = dashboard_path_for_current_user
    end
  end

  def show
      @seccion = Seccion.find(params[:id])  
      @alumnos = Alumno.where(seccion_id: params[:id])
  end

  def new
    @seccion = Seccion.new
  end

  def create
    @seccion = Seccion.new(seccion_params)
    if @seccion.save
      redirect_to seccions_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @seccion.update(seccion_params)
      redirect_to seccion_path(@seccion)
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @seccion.destroy
    redirect_to seccions_path
  end

  private
    def set_seccion
      @seccion = Seccion.find(params[:id])
    end

    def seccion_params
      params.require(:seccion).permit(:nombre_seccion, :numero_salon, :nivel_id, :docente_id, :capacidad)
    end
end
