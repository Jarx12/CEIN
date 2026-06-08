# app/controllers/coordinadora/scores_controller.rb
  class Coordinadora::ScoresController < ApplicationController
    before_action :authenticate_user!
    before_action :check_coordinadora_role!
    before_action :set_seccion

    def index
      @asignaturas = @seccion.nivel.asignaturas.order(:id)
      @enrollments = @seccion.enrollments
                             .where(academic_period: AcademicPeriod.current)
                             .includes(:alumno, :scores)
                             .order("alumnos.apellido ASC")

      @lapso_actual = (params[:lapso] || 1).to_i
    end

    def show
      @enrollment = @seccion.enrollments.find_by(id: params[:id])
      @enrollment ||= @seccion.enrollments.find_by!(alumno_id: params[:id])

      @alumno = @enrollment.alumno
      @scores = @enrollment.scores.order(:lapso)
      
      if params[:subject_id].present?
        @scores = @scores.where(asignatura_id: params[:subject_id])
      end
    end

    private

    def check_coordinadora_role!
      unless current_user&.coordinadora?
        redirect_to root_path, alert: "Acceso no autorizado."
      end
    end

    def set_seccion
      @seccion = Seccion.find(params[:seccion_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to coordinadora_dashboard_path, alert: "Sección no encontrada."
    end
end
