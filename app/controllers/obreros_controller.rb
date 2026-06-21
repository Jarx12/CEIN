class ObrerosController < ApplicationController

  before_action :set_obrero, only: %i[show edit update destroy] #Antes de show edit, update y destroy, se ejecuta set_representante (guardar en una variable un registro del modelo Representante por ID)
  before_action :authenticate_admin!
  def index
        @obreros = Obrero.all
  end

  def show
  end

  def new
    @obrero = Obrero.new
  end

  def create
    @obrero = Obrero.new(obrero_params)
    if @obrero.save
      redirect_to obreros_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @obrero.update(obrero_params)
      redirect_to obrero_path(@obrero)
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @obrero.destroy
    redirect_to obreros_path
  end

  private
  def set_obrero
    @obrero = Obrero.find(params[:id])
  end

  def obrero_params
      params.require(:obrero).permit(:name, :name2, :apellido, :apellido2, :cedula, :telefono, :direccion, :birthday, :cargo_id, :ministerio_id, :antecedentes_penales)
    end
  
  def authenticate_admin!
    unless current_user&.admin? || current_user&.directora?
      logger.warn "ALERTA DE SEGURIDAD: Usuario #{current_user&.email_address} intentó acceder a RRHH Obreros."
      redirect_to dashboard_path_for_current_user, alert: "No tienes permisos para acceder a este panel."
    end
  end

end
