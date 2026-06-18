class EventsController < ApplicationController
    allow_unauthenticated_access only: %i[cartelera]
    before_action :resume_session
    before_action :authenticate_admin!, except: %i[cartelera]
 
    def index
        # Traemos los eventos ordenados por la fecha más cercana en adelante
        @events = Event.order(event_date: :asc)
        @event = Event.new # Para el formulario de creación en la misma pantalla
    end

    def create
        @event = Event.new(event_params)
        if @event.save
        redirect_to events_path, notice: "Anuncio publicado con éxito en la cartelera."
        else
        @events = Event.order(event_date: :asc)
        render :index, status: :unprocessable_entity
        end
    end

    def destroy
        @event = Event.find(params[:id])
        @event.destroy
        redirect_to events_path, notice: "Anuncio retirado de la cartelera."
    end

    def cartelera
        @events = Event.order(event_date: :asc)
    end

    def authenticate_admin!
        if current_user.nil?
        logger.error "ERROR: No hay sesión de usuario activa."
        redirect_to new_session_path, alert: "Por favor, inicia sesión."
        elsif !current_user.admin? && !current_user.directora?
        logger.error "ERROR: El usuario #{current_user.email_address} tiene rol #{current_user.role}, no es admin o directora."
        redirect_to root_path, alert: "No tienes permiso para acceder a esta área."
        end
    end

    private

    def event_params
        params.require(:event).permit(:title, :description, :event_date, :event_time, :location, :category)
    end
    end