module Secretaria
    class AlumnosController < AlumnosController
        before_action :authenticate_secretaria!
    layout 'secretaria' 
  end
end