class ApplicationController < ActionController::Base
  include Authentication
  
  allow_browser versions: :modern

  helper_method :current_user, :authenticated?


  helper_method def dashboard_path_for_current_user
    return root_path unless authenticated?

    if current_user.profesor?
      profesor_dashboard_path
    elsif current_user.secretaria?
      secretaria_dashboard_path
    elsif current_user.coordinadora?
      coordinadora_dashboard_path
    elsif current_user.directora?
      directora_dashboard_path
    elsif current_user.admin?
      admin_dashboard_path
    else
      root_path # Ruta por defecto
    end
  end


  private

  def current_user
  Current.user
  end

  def authenticated?
    current_user.present?
  end

  def authenticate_user!
    unless authenticated?
      redirect_to new_session_path, alert: "Debes iniciar sesión para continuar."
    end
  end
  def check_profesor_role!
    unless current_user.role.to_s.downcase == "profesor"
      redirect_to root_path, alert: "Acceso denegado: Solo personal docente."
    end
  end
  def check_secretaria_role!
    unless current_user.role.to_s.downcase == "secretaria"
      redirect_to root_path, alert: "Acceso denegado: Solo personal de secretaría."
    end
  end
  def check_coordinadora_role!
    unless current_user.role.to_s.downcase == "coordinadora"
      redirect_to root_path, alert: "Acceso denegado: Solo personal de coordinación."
    end
  end
  def check_directora_role!
    unless current_user.role.to_s.downcase == "directora"
      redirect_to root_path, alert: "Acceso denegado: Solo personal de dirección."
    end
  end
  def check_admin_role!
    unless current_user.role.to_s.downcase == "admin"
      redirect_to root_path, alert: "Acceso denegado: Solo ADMIN."
    end
  end
end