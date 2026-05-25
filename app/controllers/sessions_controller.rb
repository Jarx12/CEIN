class SessionsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create, :destroy]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Intente mas Tarde" }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      session[:user_id] = user.id
      redirect_after_login(user)
    else
      redirect_to new_session_path, alert: "Credenciales de Acceso Invalidas."
    end
  end

  def destroy
    if Current.session.nil?
    Current.session = find_session_by_cookie
    end
    terminate_session
    redirect_to new_session_path, status: :see_other
  end

  private
  def redirect_after_login(user)
    case user.role
    when "profesor"
      # Si es profesor, lo mandamos a ver sus secciones (usando tu tabla seccions)
      redirect_to profesor_dashboard_path, notice: "Bienvenido, Profesor(a)"
    when "coordinadora"
      redirect_to coordinadora_dashboard_path, notice: "Bienvenido, Coordinador(a)"
    when "secretaria"
      redirect_to secretaria_dashboard_path, notice: "Bienvenido, Secretario(a)"
    when "directora"
      redirect_to admin_dashboard_path, notice: "Bienvenido, Director(a)"
    when "admin"
      redirect_to admin_dashboard_path, notice: "Bienvenido, Administrador(a)"
    else
      redirect_to root_path
    end
  end


end
