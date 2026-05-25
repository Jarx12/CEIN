class NivelesController < ApplicationController
  before_action :set_nivel, only: [:edit, :update, :destroy]
  
  def index
    @niveles = Nivel.all.order(:nombre_nivel)
  end

  def new
    @nivel = Nivel.new
  end

  def create
    @nivel = Nivel.new(nivel_params)
    if @nivel.save
      redirect_to niveles_path, notice: 'Nivel educativo creado con éxito.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @nivel.update(nivel_params)
      redirect_to niveles_path, notice: 'Nivel actualizado correctamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @nivel.seccions.any?
      redirect_to niveles_path, alert: "No se puede eliminar: Este nivel tiene #{@nivel.seccions.count} secciones asignadas."
    else
      @nivel.destroy
      redirect_to niveles_path, notice: 'Nivel eliminado correctamente.'
    end
  end

  private

  def set_nivel
    @nivel = Nivel.find(params[:id])
  end

  def nivel_params
    params.require(:nivel).permit(:nombre_nivel)
  end

end