# app/controllers/coordinadora/seccions_controller.rb
  class Coordinadora::SeccionsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_coordinadora_role!

    def seleccionar_asistencia
      @secciones = Seccion.all
    end

    def seleccionar_notas
      @secciones = Seccion.all
    end

    private

    def check_coordinadora_role!
      unless current_user&.coordinadora?
        redirect_to root_path, alert: "Acceso no autorizado al panel de coordinación."
      end
    end
end
