class Profesor::DashboardsController < ApplicationController

  before_action :authenticate_profesor!

  def show
    # Buscar el registro de Docente vinculado al User
    @docente = current_user.person 
    
    # Obtener las secciones que tiene asignadas
    @secciones = Seccion.where(docente_id: @docente.id).includes(:nivel)
  end

  private

def authenticate_profesor!
    if current_user.nil?
      logger.error "ERROR: No hay sesión de usuario activa."
      redirect_to new_session_path, alert: "Por favor, inicia sesión."
    elsif !current_user.profesor?
      logger.error "ERROR: El usuario #{current_user.email_address} tiene rol #{current_user.role}, no es profesor."
      redirect_to root_path, alert: "No tienes permiso para acceder a esta área."
    end
  end
end