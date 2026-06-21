class CargosController < ApplicationController

  before_action :set_cargo, only: %i[edit update destroy] #Antes de edit, update y destroy, se ejecuta set_cargo (guardar en una variable un registro del modelo Cargo por ID)
  before_action :authenticate_admin!
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
    def authenticate_admin!
        unless current_user&.admin? || current_user&.directora?
          logger.warn "ALERTA DE SEGURIDAD: Usuario #{current_user&.email_address} intentó acceder a RRHH Cargos."
          redirect_to dashboard_path_for_current_user, alert: "No tienes permisos para acceder a este panel."
        end
      end

end
