class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

    enum :role, { 
    profesor: 0, 
    coordinadora: 1, 
    secretaria: 2, 
    directora: 3,
    admin: 4 
  }, default: :profesor

  belongs_to :person, polymorphic: true, optional: true
  validates :email_address, presence: true, uniqueness: true

  def superuser?
    self.role == "admin"
  end
  def display_name
    return "Administrador" if superuser?
    person&.name || email_address
  end
end