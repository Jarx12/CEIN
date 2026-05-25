module Secretaria
  class SeccionsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_secretaria_role!

    def seleccionar_asistencia
      @secciones = Seccion.all 
    end
    
    def seleccionar_notas
      @secciones = Seccion.all
    end
    private

    def check_secretaria_role!
      unless current_user&.secretaria?
        redirect_to root_path, alert: "Acceso no autorizado."
      end
    end
  end
end