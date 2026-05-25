class CargosController < ApplicationController

  before_action :set_cargo, only: %i[edit update destroy] #Antes de edit, update y destroy, se ejecuta set_cargo (guardar en una variable un registro del modelo Cargo por ID)

  def index
    @cargos = Cargo.all
  end


  def new
    @cargo = Cargo.new
  end

  def create
    @cargo = Cargo.new(cargo_params)
    if @cargo.save
      redirect_to cargos_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @cargo.update(cargo_params)
      redirect_to cargos_path
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @cargo.destroy
    redirect_to cargos_path
  end

  private
    def set_cargo
      @cargo = Cargo.find(params[:id])
    end

    def cargo_params
      params.require(:cargo).permit(:nombre_cargo)
    end
end
