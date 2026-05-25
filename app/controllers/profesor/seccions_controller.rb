class Profesor::SeccionsController < ApplicationController
  before_action :authenticate_profesor!
  before_action :set_seccion, only: [:show]


    def show
        # Filtramos los enrollments para que solo traiga los del periodo actual
        @enrollments = @seccion.enrollments
                            .where(academic_period: AcademicPeriod.current)
                            .includes(:alumno)
                            .order("alumnos.apellido ASC")
        
        # Opcional: Validar si la sección no tiene alumnos este periodo
        if @enrollments.empty?
        flash.now[:notice] = "Esta sección aún no tiene alumnos inscritos para el periodo actual."
        end
    end

  private

  def authenticate_profesor!
    unless current_user&.profesor?
      redirect_to root_path, alert: "Acceso denegado. Área exclusiva para docentes."
    end
  end

  def set_seccion
    @docente = current_user.person
    @seccion = Seccion.where(docente_id: @docente.id).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to profesor_dashboard_path, alert: "No tienes permiso para ver esta sección."
  end
end