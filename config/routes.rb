# config/routes.rb
Rails.application.routes.draw do
  get "admin/index"
  # 1. Autenticación
  resource :session
  resources :passwords, param: :token
  
  # 2. Raíz y Presentación
  root "presentacion#index"
  get "/presentacion/info", to: "presentacion#info"
  get "/rrhh", to: "presentacion#rrhh", as: "rrhh"
  get "/zadmin", to: "presentacion#zadmin", as: "zadmin"

  # 3.1 Área del Profesor
  namespace :profesor do
    resource :dashboard, only: [:show]
    resources :seccions, only: [:show] do
      resources :scores, only: [:index, :new, :create, :update, :show] do
        collection do
        get :planilla 
        post :bulk_update
        end
      end
      resources :attendances, only: [:index, :create, :show] do
        collection do
        get :nueva_lista
        post :guardar
        end
      end
    end
  end

  # 3.2 Área de la Secretaria
  namespace :secretaria do
  get 'dashboard', to: 'dashboards#show', as: :dashboard
  
  resources :seccions, only: [:index] do
    collection do
      get :seleccionar_asistencia
      get :seleccionar_notas
    end
    resources :attendances, only: [:index, :show]
    resources :scores, only: [:index, :show]
  end
end



  # 4. Otros Dashboards de Rol
  get 'coordinadora/dashboard', to: 'coordinadora/dashboards#show', as: :coordinadora_dashboard
  get 'admin/dashboard', to: 'admin/dashboards#show', as: :admin_dashboard

  # 5. Recursos Administrativos (CRUD)
  resources :alumnos
  resources :docentes
  resources :administrativos
  resources :obreros
  resources :seccions
  resources :enrollments, only: [:create, :new]
  
  resources :representantes do
    get :preview, on: :collection
  end

  resources :academic_periods do
    member do
      patch :activate
      patch :close
    end
  end

  # 6. Recursos Académicos Específicos
  resources :niveles, except: [:show]
  resources :asignaturas, except: [:show]
  resources :cargos, except: [:show]

  # 7. Gestión de Notas y Asistencia (General/Admin)
  resources :scores, except: [:show] do
    collection do
      get :selector
      get :bulk_edit
      post :bulk_update
      get 'alumno/:id', to: 'scores#notas_por_alumno', as: :alumno # Ruta personalizada
    end
  end

  resources :attendances, only: [:index, :show, :destroy] do
    collection do
      get :seleccionar_seccion
      get :nueva_lista, as: :tomar # Alias para tomar_asistencia
      post :guardar
    end
  end

  # Salud del sistema
  get "up" => "rails/health#show", as: :rails_health_check
end