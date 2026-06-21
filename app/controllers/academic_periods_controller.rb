# app/controllers/academic_periods_controller.rb
class AcademicPeriodsController < ApplicationController

before_action :set_academic_period, only: [:edit, :update, :show, :activate, :close]
before_action :authenticate_admin!

def index
    @academic_periods = AcademicPeriod.order(created_at: :desc)
  end

def show
  end
  
def new
    @academic_period = AcademicPeriod.new
  end


def create
    @academic_period = AcademicPeriod.new(academic_period_params)
    if @academic_period.save
      redirect_to academic_periods_path, notice: "Periodo creado con éxito."
    else
      render :new, status: :unprocessable_entity
    end
  end

def edit    
  end

  def update
    if @academic_period.update(academic_period_params)
      redirect_to academic_periods_path, notice: 'Periodo actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end




def activate
  @academic_period = AcademicPeriod.find(params[:id])
  @academic_period.activate!
  redirect_to academic_periods_path, notice: "Periodo #{@academic_period.name} activado y otros cerrados."
end

def close
  @academic_period = AcademicPeriod.find(params[:id])
  @academic_period.close!
  redirect_to academic_periods_path, notice: "Periodo #{@academic_period.name} ha sido cerrado."
end




private
def set_academic_period
    @academic_period = AcademicPeriod.find(params[:id])
  end

def academic_period_params
    params.require(:academic_period).permit(:name, :start_date, :end_date)

end

def authenticate_admin!
    unless current_user&.admin? || current_user&.directora?
      logger.warn "ALERTA DE SEGURIDAD: Usuario #{current_user&.email_address} intentó acceder a ZADMIN."
      redirect_to dashboard_path_for_current_user, alert: "No tienes permisos para acceder a este panel."
    end
  end


end