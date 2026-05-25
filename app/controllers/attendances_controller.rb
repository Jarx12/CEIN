class AttendancesController < ApplicationController
  before_action :set_seccion, only: [:nueva_lista]

  # 1. EVITA DUPLICADOS: Trae las fechas únicas del historial general
  def index
    @fechas = Attendance.select(:fecha).distinct.order(fecha: :desc)  
  end

  # 2. EVITA DUPLICADOS EN VISTA: Filtra limpiamente por fecha sin cruzar tablas propensas a repetir filas
  def show
    @fecha = Date.parse(params[:id]) # Convertimos el string de la URL a Date seguro
    @attendances = Attendance.where(fecha: @fecha)
                             .includes(:alumno)
                             .order("alumnos.apellido ASC") # Ordenamiento limpio por apellido
  rescue Date::Error
    redirect_to attendances_path, alert: "Fecha inválida."
  end

  # 3. PREPARA LA LISTA CORRECTAMENTE
  def nueva_lista
    @fecha = params[:fecha].present? ? Date.parse(params[:fecha]) : Date.today
    
    # Obtenemos los alumnos inscritos en el período actual para esa sección
    @alumnos = Alumno.joins(:enrollments)
                     .where(enrollments: { 
                       seccion_id: @seccion.id, 
                       academic_period_id: AcademicPeriod.current&.id 
                     })
                     .order("alumnos.apellido ASC")

    # Inicializamos registros en memoria si no existen, sin disparar escrituras agresivas en DB aquí
  end

  # 4. BLINDADO: Si todos los switches se apagan, actualiza todo a FALSE correctamente sin romperse
def guardar
  fecha = params[:fecha].present? ? Date.parse(params[:fecha]) : Date.today
  
  # Intenta capturar el seccion_id de cualquier lugar donde pueda venir
  seccion_id_presente = params[:seccion_id] || params.dig(:attendance, :seccion_id)
  @seccion = Seccion.find_by(id: seccion_id_presente)

  if @seccion.nil?
    redirect_to attendances_path, alert: "Sección no especificada o inválida." and return
  end

  # Obtenemos los alumnos de la sección elegida
  alumnos_ids = Alumno.joins(:enrollments)
                      .where(enrollments: { seccion_id: @seccion.id, academic_period_id: AcademicPeriod.current&.id })
                      .pluck(:id)

  # Procesamos las asistencias en lote de forma segura
  Attendance.transaction do
    alumnos_ids.each do |alumno_id|
      asistencias_hash = params[:attendance] || params[:Attendance]
      valor_presencia = asistencias_hash.present? && (asistencias_hash[alumno_id.to_s] == "true" || asistencias_hash[alumno_id.to_s] == "1")

      attendance = Attendance.find_or_initialize_by(
        alumno_id: alumno_id, 
        fecha: fecha
      )
      
      attendance.presente = valor_presencia
      attendance.save!
    end
  end

  redirect_to attendances_path, notice: "Asistencia de la sección #{@seccion.nombre_seccion} procesada con éxito."

rescue Date::Error
  redirect_to attendances_path, alert: "Fecha inválida."
rescue => e
  redirect_to attendances_path, alert: "Error al guardar la asistencia: #{e.message}"
end

  def seleccionar_seccion
    @secciones = Seccion.all
  end

def destroy
  # 1. Buscamos el registro individual usando su ID único de base de datos
  @attendance = Attendance.find_by(id: params[:id])

  if @attendance
    # Guardamos la fecha antes de borrar para poder regresar a la misma vista si quieres,
    # o simplemente para armar el mensaje de éxito estructurado.
    fecha_registro = @attendance.fecha.strftime("%d/%m/%Y")
    alumno_nombre = @attendance.alumno&.nombre_completo

    # 2. Borramos ÚNICAMENTE este registro
    @attendance.destroy

    # Redirigimos al index general o puedes usar redirect_back si prefieres quedarte ahí
    redirect_to attendances_path, notice: "Asistencia de #{alumno_nombre} para el día #{fecha_registro} eliminada exitosamente."
  else
    redirect_to attendances_path, alert: "No se encontró el registro de asistencia que intenta eliminar."
  end
end

  private

  def set_seccion
    @seccion = Seccion.find(params[:seccion_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to attendances_path, alert: "Selecciona una sección válida."
  end
end