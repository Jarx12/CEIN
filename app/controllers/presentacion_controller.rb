class PresentacionController < ApplicationController
    require 'ostruct'
    allow_unauthenticated_access only: %i[ index info]
    before_action :resume_session
  def index
  end
  def info
  end
  def rrhh
  end
  def zadmin
  end

end
