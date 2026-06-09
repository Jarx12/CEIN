module ApplicationHelper
def user_dashboard_path
    return root_path unless current_user
    case current_user.role
    when 'admin'
      admin_dashboard_path
    when 'directora'
      directora_dashboard_path
    when 'coordinadora'
        coordinadora_dashboard_path 
    when 'profesor'
      profesor_dashboard_path 
    when 'secretaria'
      secretaria_dashboard_path 
    else
      root_path
    end
  end
end
