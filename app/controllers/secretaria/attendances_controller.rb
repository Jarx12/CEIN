module Secretaria
  class AttendancesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_secretaria_role!
    before_action :set_seccion, only: [:index, :show]

    # Historial de fechas en las que se ha tomado asistencia en la sección elegida
    def index
      @fechas = Attendance.joins(alumno: :enrollments)
                          .where(enrollments: { seccion_id: @seccion.id })
                          .select(:fecha)
                          .distinct
                          .order(fecha: :desc)
    end

    def seleccionar_asistencia
      # Cargamos todas las secciones disponibles en el sistema
      @secciones = Seccion.all 
    end

    # Ver el detalle (la lista completa) de asistencia de un día específico
    def show
      @fecha = Date.parse(params[:id])
      
      # Buscamos los alumnos inscritos en esta sección para el periodo actual
      alumno_ids = @seccion.enrollments
                           .where(academic_period: AcademicPeriod.current)
                           .pluck(:alumno_id)

      # Traemos los estados de asistencia de esos alumnos para esa fecha
      @attendances = Attendance.where(fecha: @fecha, alumno_id: alumno_ids)
                               .includes(:alumno)
                               .order("alumnos.apellido ASC") # Mismo orden oficial que el profesor
    rescue Date::Error
      redirect_to secretaria_seccion_attendances_path(@seccion), alert: "Fecha inválida."
    end

    private

    def check_secretaria_role!
      unless current_user&.secretaria?
        redirect_to root_path, alert: "Acceso no autorizado al panel de secretaría."
      end
    end

    def set_seccion
      # A diferencia del profesor, la secretaria puede buscar CUALQUIER sección
      # porque no está limitada a su propio `docente_id`.
      @seccion = Seccion.find(params[:seccion_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to secretaria_dashboard_path, alert: "Sección no encontrada."
    end
  end
end