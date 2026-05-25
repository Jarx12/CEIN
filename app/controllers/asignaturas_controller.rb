class AsignaturasController < ApplicationController

  before_action :set_asignatura, only: %i[edit update destroy] #Antes de show edit, update y destroy, se ejecuta set_asignatura (guardar en una variable un registro del modelo Asignatura por ID)

  def index
    @asignaturas = Asignatura.includes(:nivel).all
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
end
