# app/controllers/secretaria/scores_controller.rb
module Secretaria
  class ScoresController < ApplicationController
    before_action :authenticate_user!
    before_action :check_secretaria_role!
    before_action :set_seccion

    # Muestra la sábana o matriz general de notas de la sección elegida
    def index
      @asignaturas = @seccion.nivel.asignaturas.order(:id)
      @enrollments = @seccion.enrollments
                             .where(academic_period: AcademicPeriod.current)
                             .includes(:alumno, :scores)
                             .order("alumnos.apellido ASC")

      @lapso_actual = (params[:lapso] || 1).to_i
    end

    # Muestra el boletín de notas / reporte individual de un alumno específico
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

    def check_secretaria_role!
      unless current_user&.secretaria?
        redirect_to root_path, alert: "Acceso no autorizado al panel de secretaría."
      end
    end

    def set_seccion
      @seccion = Seccion.find(params[:seccion_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to secretaria_dashboard_path, alert: "Sección no encontrada."
    end
  end
end