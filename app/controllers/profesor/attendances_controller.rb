class Profesor::AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_profesor_role!
  before_action :set_seccion_segura

  # Lista de fechas en las que se ha tomado asistencia en la sección
  def index
    @fechas = Attendance.joins(alumno: :enrollments)
                        .where(enrollments: { seccion_id: @seccion.id })
                        .select(:fecha).distinct.order(fecha: :desc)
  end

  # Ver el detalle de asistencia de una fecha específica
    def show
    @fecha = Date.parse(params[:id])
    
    # Buscamos los IDs de los alumnos inscritos actualmente en esta sección
    alumno_ids = @seccion.enrollments
                        .where(academic_period: AcademicPeriod.current)
                        .pluck(:alumno_id)

    # Traemos las asistencias de esos alumnos para la fecha específica
    @attendances = Attendance.where(fecha: @fecha, alumno_id: alumno_ids)
                            .includes(:alumno)
                            .order("alumno.apellido ASC")
    rescue Date::Error
    redirect_to profesor_seccion_attendances_path(@seccion), alert: "Fecha inválida."
    end

  # Formulario para marcar asistencia
  def nueva_lista
    @fecha = params[:fecha] || Date.today
    # Obtenemos los inscritos de la sección del profesor
    @enrollments = @seccion.enrollments
                           .where(academic_period: AcademicPeriod.current)
                           .includes(:alumno)
                           .order("alumnos.apellido ASC")
  end

    def guardar
    fecha = params[:fecha].present? ? Date.parse(params[:fecha]) : Date.today
    
    # Si tenemos la fecha, procesamos, aunque params[:asistencia] sea nil (todos ausentes)
    Attendance.transaction do
        @seccion.enrollments.each do |enrollment|
        alumno_id = enrollment.alumno_id
        
        # Si params[:asistencia] no existe (todos false) o este ID no está (ese alumno false)
        # el valor será false.
        valor_presencia = params[:asistencia].present? && params[:asistencia][alumno_id.to_s] == "true"

        attendance = Attendance.find_or_initialize_by(
            alumno_id: alumno_id, 
            fecha: fecha
        )
        
        attendance.presente = valor_presencia
        attendance.save!
        end
    end

    redirect_to profesor_seccion_path(@seccion), notice: "Asistencia actualizada correctamente."

    rescue Date::Error
    redirect_to profesor_seccion_path(@seccion), alert: "Fecha inválida."
    rescue => e
    redirect_to profesor_seccion_path(@seccion), alert: "Error técnico: #{e.message}"
    end

  private

  def set_seccion_segura
    @seccion = Seccion.where(docente_id: current_user.person_id).find(params[:seccion_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Acceso no autorizado a esta sección."
  end
end