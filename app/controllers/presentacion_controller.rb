class PresentacionController < ApplicationController
    require 'ostruct'
    allow_unauthenticated_access only: %i[index noticias vision_mision consulta_publica]
    before_action :resume_session
  def index
  end
  def noticias
  end
  def vision_mision
  end
  def consulta_publica
  end
  def rrhh
  end
  def zadmin
  end
  def nomina_completa
  @docentes = Docente.all
    @obreros = Obrero.all
    @administrativos = Administrativo.all

    # Calculamos el total macro de la institución
    @total_personal = @docentes.count + @obreros.count + @administrativos.count

    # Mapeamos y unificamos todo el universo de personal en una única lista ordenada
    @nomina_unificada = []

    @docentes.each do |d|
      @nomina_unificada << OpenStruct.new(
        instance: d,
        tipo: "Docente",
        color_badge: "bg-warning-subtle text-warning-emphasis",
        initials_bg: "background-color: #fef9c3; color: #854d0e;",
        name: d.name,
        apellido: d.apellido,
        cedula: d.cedula,
        fecha_ingreso: d.respond_to?(:fecha_ingreso) ? d.fecha_ingreso : d.created_at
      )
    end

    @administrativos.each do |a|
      @nomina_unificada << OpenStruct.new(
        instance: a,
        tipo: "Administrativo",
        color_badge: "bg-primary-subtle text-primary-emphasis",
        initials_bg: "background-color: #dbeafe; color: #1e40af;",
        name: a.name,
        apellido: a.apellido,
        cedula: a.cedula,
        fecha_ingreso: a.respond_to?(:fecha_ingreso) ? a.fecha_ingreso : a.created_at
      )
    end

    @obreros.each do |o|
      @nomina_unificada << OpenStruct.new(
        instance: o,
        tipo: "Obrero",
        color_badge: "bg-danger-subtle text-danger-emphasis",
        initials_bg: "background-color: #fee2e2; color: #991b1b;",
        name: o.name,
        apellido: o.apellido,
        cedula: o.cedula,
        fecha_ingreso: o.respond_to?(:fecha_ingreso) ? o.fecha_ingreso : o.created_at
      )
    end

    # Ordenamos por fecha de ingreso para que el reporte sea limpio
    @nomina_unificada.sort_by! { |empleado| empleado.fecha_ingreso.to_s.downcase }
  end

end
