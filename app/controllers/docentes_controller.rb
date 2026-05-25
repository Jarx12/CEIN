class DocentesController < ApplicationController

  before_action :set_docente, only: %i[show edit update destroy] #Antes de show edit, update y destroy, se ejecuta set_docente (guardar en una variable un registro del modelo Docente por ID)

  def index
        @docentes = Docente.all
  end

  def show
  end

  def new
    @docente = Docente.new
  end

  def create
    @docente = Docente.new(docente_params)
    if @docente.save
      redirect_to docentes_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @docente.update(docente_params)
      redirect_to docente_path(@docente)
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @docente.destroy
    redirect_to docentes_path
  end

  private
  def set_docente
    @docente = Docente.find(params[:id])
  end

  def docente_params
      params.require(:docente).permit(:name, :name2, :apellido, :apellido2, :cedula, :telefono, :direccion, :birthday, :ministerio_id, :foto_titulo, :antecedentes_penales)
    end
end
