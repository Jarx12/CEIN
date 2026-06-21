class RepresentantesController < ApplicationController

  before_action :set_representante, only: %i[show edit update destroy] #Antes de show edit, update y destroy, se ejecuta set_representante (guardar en una variable un registro del modelo Representante por ID)
  before_action :authenticate_users!
  def index
        @representantes = Representante.all
  end

  def show
  end

  def new
    @representante = Representante.new
  end

  def create
    @representante = Representante.new(representante_params)
    if @representante.save
      redirect_to representantes_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @representante.update(representante_params)
      redirect_to representante_path(@representante)
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @representante.destroy
    redirect_to representantes_path
  end

  def preview
  @representante = Representante.find_by(cedula: params[:cedula])
  @frame_id = params[:frame_id] || "representante_name" # Fallback to primary if nil
  render layout: false
  end

  private
  def set_representante
    @representante = Representante.find(params[:id])
  end

  def representante_params
      params.require(:representante).permit(:name, :name2, :apellido, :apellido2, :cedula, :telefono, :direccion, :birthday)
  end
end


private
  def authenticate_users!
      unless current_user&.admin? || current_user&.directora? || current_user&.coordinadora? || current_user&.secretaria?
        logger.warn "ALERTA DE SEGURIDAD: Usuario #{current_user&.email_address} intentó acceder a Representantes."
        redirect_to dashboard_path_for_current_user, alert: "No tienes permisos para acceder a este panel."
      end
    end

