# app/controllers/coordinadora/attendances_controller.rb
module Coordinadora
  class AttendancesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_coordinadora_role!
    before_action :set_seccion, only: [:index, :show]

    # Historial de fechas en las que se ha tomado asistencia (Copiado de Secretaría)
    def index
      @fechas = Attendance.joins(alumno: :enrollments)
                          .where(enrollments: { seccion_id: @seccion.id })
                          .select(:fecha)
                          .distinct
                          .order(fecha: :desc)
    end

    # Ver el detalle de asistencia de un día específico (Copiado de Secretaría)
    def show
      @fecha = Date.parse(params[:id])
      
      # Buscamos los alumnos inscritos en esta sección para el periodo actual
      alumno_ids = @seccion.enrollments
                           .where(academic_period: AcademicPeriod.current)
                           .pluck(:alumno_id)

      # Traemos los estados de asistencia de esos alumnos para esa fecha
      @attendances = Attendance.where(fecha: @fecha, alumno_id: alumno_ids)
                               .includes(:alumno)
                               .order("alumnos.apellido ASC")
    rescue Date::Error
      redirect_to coordinadora_seccion_attendances_path(@seccion), alert: "Fecha inválida."
    end

    private

    def check_coordinadora_role!
      unless current_user&.coordinadora?
        redirect_to root_path, alert: "Acceso no autorizado al panel de coordinación."
      end
    end

    def set_seccion
      @seccion = Seccion.find(params[:seccion_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to coordinadora_dashboard_path, alert: "Sección no encontrada."
    end
  end
end