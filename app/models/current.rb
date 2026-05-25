class Current < ActiveSupport::CurrentAttributes
  attribute :session
  
  # Delegate permite acceder a Current.user directamente
  delegate :user, to: :session, allow_nil: true
end