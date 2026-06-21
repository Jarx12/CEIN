# app/controllers/enrollments_controller.rb
class EnrollmentsController < ApplicationController
  before_action :authenticate_users!
  def create
    @student = Student.find(params[:student_id])
    @periodo_activo = AcademicPeriod.current

    if @periodo_activo.nil?
      redirect_to academic_periods_path, alert: "No hay un periodo escolar activo. Abre uno primero."
      return
    end

    @enrollment = @student.enrollments.build(enrollment_params)
    @enrollment.academic_period = @periodo_activo

    if @enrollment.save
      redirect_to @student, notice: "Alumno inscrito exitosamente en #{@periodo_activo.name}."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def enrollment_params
    params.require(:enrollment).permit(:grade_level, :section)
  end
  def authenticate_users!
    unless current_user&.admin? || current_user&.directora? || current_user&.coordinadora? || current_user&.secretaria?
      logger.warn "ALERTA DE SEGURIDAD: Usuario #{current_user&.email_address} intentó acceder a Inscripciones."
      redirect_to dashboard_path_for_current_user, alert: "No tienes permisos para acceder a este panel."
    end
  end
end