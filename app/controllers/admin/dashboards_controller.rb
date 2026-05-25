class Admin::DashboardsController < ApplicationController

  before_action :authenticate_admin!

  def show
  end

  private

def authenticate_admin!
    if current_user.nil?
      logger.error "ERROR: No hay sesión de usuario activa."
      redirect_to new_session_path, alert: "Por favor, inicia sesión."
    elsif !current_user.admin?
      logger.error "ERROR: El usuario #{current_user.email_address} tiene rol #{current_user.role}, no es administrador."
      redirect_to root_path, alert: "No tienes permiso para acceder a esta área."
    end
  end
end