class AdministrativosController < ApplicationController

  before_action :set_administrativo, only: %i[show edit update destroy] #Antes de show edit, update y destroy, se ejecuta set_administrativo (guardar en una variable un registro del modelo Administrativo por ID)

  def index
        @administrativos = Administrativo.all
  end

  def show
  end

  def new
    @administrativo = Administrativo.new
  end

  def create
    @administrativo = Administrativo.new(administrativo_params)
    if @administrativo.save
      redirect_to administrativos_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @administrativo.update(administrativo_params)
      redirect_to administrativo_path(@administrativo)
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @administrativo.destroy
    redirect_to administrativos_path
  end

  private
  def set_administrativo
    @administrativo = Administrativo.find(params[:id])
  end

  def administrativo_params
      params.require(:administrativo).permit(:name, :name2, :apellido, :apellido2, :cedula, :telefono, :direccion, :birthday, :cargo_id, :ministerio_id, :foto_titulo, :antecedentes_penales)
    end
end
